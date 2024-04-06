#[flutter_rust_bridge::frb]
pub struct WrappedChat {
    pub conversation_id: String,
    #[frb(non_final)]
    pub chat_name: String,
    pub tone: String,
    pub update_time_local: String,
    pub plugins: Vec<String>,
}

#[flutter_rust_bridge::frb]
pub struct WrappedMsg {
    pub author: String,
    pub text: String,
}
