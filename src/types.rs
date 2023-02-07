use serde::Deserialize;
use std::collections::HashMap;

#[derive(Default, Deserialize)]
pub struct PackageJson {
    pub name: String,
    pub scripts: Option<HashMap<String, String>>,
}
