use tracing::info;

use crate::api::bing_client_wrap::ROOT_PATH;

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}

#[flutter_rust_bridge::frb]
pub async fn init_root_path(path: String) {
    info!("Init root path: {}", path);
    let mut root_path = ROOT_PATH.write().await;
    (*root_path) = path;
}

#[flutter_rust_bridge::frb]
pub async fn init_logger() {
    tracing_subscriber::fmt().init();
}
