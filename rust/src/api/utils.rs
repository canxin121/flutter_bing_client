use anyhow::Result;
use flutter_rust_bridge;
use time::{format_description::well_known::Rfc3339, OffsetDateTime, UtcOffset};
use uuid::Uuid;
#[flutter_rust_bridge::frb(sync)]
pub fn generate_uuidv4_string() -> String {
    Uuid::new_v4().to_string()
}

#[flutter_rust_bridge::frb(sync)]
pub fn read_file(path: String) -> Result<String> {
    let content = std::fs::read_to_string(path)?;
    Ok(content)
}

pub fn gen_time_local(time: Option<u64>) -> String {
    match time {
        Some(time) => match OffsetDateTime::from_unix_timestamp((time / 1000) as i64) {
            Ok(datetime) => match UtcOffset::local_offset_at(datetime) {
                Ok(offset) => {
                    let datetime_with_offset = datetime.to_offset(offset);
                    match datetime_with_offset.format(&Rfc3339) {
                        Ok(formatted) => formatted,
                        Err(_) => "Error formatting time".to_string(),
                    }
                }
                Err(_) => "Error calculating local offset".to_string(),
            },
            Err(_) => "Error converting timestamp".to_string(),
        },
        None => "Unknown Time".to_string(),
    }
}
