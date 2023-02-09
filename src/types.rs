use ahash::AHashMap;
use serde::Deserialize;

#[derive(Debug, Default, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct PackageJson {
    pub name: String,
    pub scripts: Option<AHashMap<String, String>>,
    pub dependencies: Option<AHashMap<String, String>>,
    pub dev_dependencies: Option<AHashMap<String, String>>,
    pub peer_dependencies: Option<AHashMap<String, String>>,
}
