use std::sync::Arc;

use crate::frb_generated::StreamSink;
use bing_client::{BingClient, Chat, Cookie, Plugin, Tone, UserInput};
use dashmap::DashMap;
use genawaiter::GeneratorState;
use lazy_static::lazy_static;
use tokio::{
    fs::{self, OpenOptions},
    io::AsyncWriteExt,
    sync::RwLock,
};

use tracing::{error, info};

use super::{
    bing_client_types::{WrappedChat, WrappedMsg},
    utils::gen_time_local,
};

lazy_static! {
    pub static ref BING_CLIENT: Arc<RwLock<Option<BingClient>>> = Arc::new(RwLock::new(None));
    pub static ref CHAT_LIST: DashMap<String, Chat> = DashMap::new();
    pub static ref ROOT_PATH: Arc<RwLock<String>> = Arc::new(RwLock::new(String::new()));
    pub static ref STOP_SIGNALS: DashMap<String, Box<dyn Fn() + Send + Sync>> = DashMap::new();
}

#[flutter_rust_bridge::frb]
pub async fn display_global_state() {
    let bing_client = BING_CLIENT.read().await;
    info!("BING_CLIENT: {:?}", *bing_client);
    info!("CHAT_LIST len: {}", CHAT_LIST.len());

    let root_path = ROOT_PATH.read().await;
    info!("ROOT_PATH: {:?}", *root_path);

    info!("STOP_SIGNALS len: {}", STOP_SIGNALS.len());
}

#[flutter_rust_bridge::frb]
pub async fn try_load_client() -> Result<(), anyhow::Error> {
    let root_path = {
        let root_path = ROOT_PATH.read().await;
        root_path.clone()
    };
    let file_path = root_path + "/client.json";
    info!("Trying to load bing client from: {}",file_path);
    let client_json = fs::read_to_string(file_path).await?;
    let client = serde_json::from_str::<BingClient>(&client_json)?;
    let mut global_client = BING_CLIENT.write().await;
    (*global_client) = Some(client);
    Ok(())
}

#[flutter_rust_bridge::frb]
pub async fn recreate_client_save(cookie_str: String) -> Result<(), anyhow::Error> {
    info!("Trying to recreate bing client");
    let client = BingClient::build(&Cookie::HeadStr(cookie_str.clone())).await?;
    let client_json = serde_json::to_string(&client)?;
    let mut global_client = BING_CLIENT.write().await;
    (*global_client) = Some(client);

    let root_path = {
        let root_path = ROOT_PATH.read().await;
        root_path.clone()
    };

    let path = &(root_path + "/client.json");
    info!("Will write to {path}");
    let mut file = OpenOptions::new()
        .write(true)
        .create(true)
        .truncate(true)
        .open(path)
        .await?;
    file.write_all(client_json.as_bytes()).await?;
    Ok(())
}

pub async fn get_update_chat_list() -> Result<Vec<WrappedChat>, anyhow::Error> {
    let bing_client = BING_CLIENT.read().await;
    if let Some(client) = bing_client.as_ref() {
        let chats = client.get_chat_list().await?;
        let _ = chats.iter().for_each(|chat| {
            let _ = CHAT_LIST.insert(chat.conversation_id.clone(), chat.clone());
        });
        Ok(chats
            .into_iter()
            .map(|chat| WrappedChat {
                conversation_id: chat.conversation_id,
                chat_name: chat.chat_name.unwrap_or("No Title".to_string()),
                tone: chat.tone.unwrap_or("Unknown Tone".to_string()),
                update_time_local: gen_time_local(chat.update_time_utc),
                plugins: chat
                    .plugins
                    .iter()
                    .map(|plugin| plugin.get_name())
                    .collect::<Vec<String>>(),
            })
            .collect::<Vec<WrappedChat>>())
    } else {
        Err(anyhow::anyhow!("Bing Client is not inited"))
    }
}

#[flutter_rust_bridge::frb]
pub async fn get_chat_msgs(id: String) -> Result<Vec<WrappedMsg>, anyhow::Error> {
    if let Some(mut chat) = CHAT_LIST.get_mut(&id) {
        let bing_client = BING_CLIENT.read().await;
        if let Some(client) = bing_client.as_ref() {
            Ok(client
                .get_chat_messages(&mut chat)
                .await?
                .iter()
                .map(|msg| WrappedMsg {
                    author: msg.author.to_string(),
                    text: msg.to_string(),
                })
                .collect::<Vec<WrappedMsg>>())
        } else {
            info!("In get_chat_msgs");
            display_global_state().await;
            return Err(anyhow::anyhow!("Bing Client is not inited"));
        }
    } else {
        display_global_state().await;
        Err(anyhow::anyhow!("Chat Not Found"))
    }
}

#[flutter_rust_bridge::frb]
pub async fn create_chat() -> Result<String, anyhow::Error> {
    let bing_client = BING_CLIENT.read().await;
    if let Some(client) = bing_client.as_ref() {
        let new_chat = client.create_chat().await?;
        CHAT_LIST.insert(new_chat.conversation_id.clone(), new_chat.clone());
        Ok(new_chat.conversation_id)
    } else {
        Err(anyhow::anyhow!("Bing Client is not inited"))
    }
}

#[flutter_rust_bridge::frb]
pub async fn rename_chat(id: String, new_name: String) -> Result<(), anyhow::Error> {
    if let Some(mut chat) = CHAT_LIST.get_mut(&id) {
        let bing_client = BING_CLIENT.read().await;
        if let Some(client) = bing_client.as_ref() {
            client.rename_chat(&mut chat, new_name).await?;
        } else {
            return Err(anyhow::anyhow!("Bing Client is not inited"));
        }
    }
    Ok(())
}

#[flutter_rust_bridge::frb]
pub async fn delete_chat(id: String) -> Result<(), anyhow::Error> {
    if let Some(mut chat) = CHAT_LIST.get_mut(&id) {
        let bing_client = BING_CLIENT.read().await;
        if let Some(client) = bing_client.as_ref() {
            client.delete_chat(&mut chat).await?;
        } else {
            return Err(anyhow::anyhow!("Bing Client is not inited"));
        }
    }
    Ok(())
}

#[flutter_rust_bridge::frb]
pub async fn ask_stream_plain(
    chat: WrappedChat,
    text_msg: String,
    image_path: Option<String>,
    sink: StreamSink<String>,
) -> Result<(), anyhow::Error> {
    if let Some(mut _chat) = CHAT_LIST.get_mut(&chat.conversation_id) {
        let bing_client = BING_CLIENT.read().await;
        if let Some(client) = bing_client.as_ref() {
            let user_input = UserInput::build(
                text_msg,
                {
                    if let Some(path) = image_path {
                        Some(bing_client::Image::Path(path))
                    } else {
                        None
                    }
                },
                Tone::build_by_name(&chat.tone).unwrap_or(Tone::Creative),
                chat.plugins
                    .iter()
                    .filter_map(|name| Plugin::build_by_name(name))
                    .collect::<Vec<Plugin>>(),
                &_chat,
                &client,
            )
            .await
            .unwrap();
            let (mut stream, stop_fn) = client
                .ask_stream_plain(&mut _chat, user_input)
                .await
                .unwrap();

            STOP_SIGNALS.insert(chat.conversation_id.clone(), Box::new(stop_fn));

            while let GeneratorState::Yielded(data) = stream.async_resume().await {
                match sink.add(data) {
                    Ok(_) => {}
                    Err(e) => {
                        error!("Failed to trans answer: {e}");
                    }
                }
            }
        } else {
            return Err(anyhow::anyhow!("Bing Client is not inited"));
        }
    };
    Ok(())
}

#[flutter_rust_bridge::frb]
pub fn stop_answer(id: String) -> Result<(), anyhow::Error> {
    if let Some(stop_fn) = STOP_SIGNALS.get(&id) {
        stop_fn.as_ref()();
        Ok(())
    } else {
        return Err(anyhow::anyhow!("Stop Signal Not Found"));
    }
}
