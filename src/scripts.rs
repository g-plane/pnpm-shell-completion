use crate::monorepo::{read_package_jsons, read_root_package_json};
use itertools::Itertools;

pub async fn provide_scripts_candidate(target_pkg: Option<&str>) -> anyhow::Result<String> {
    let scripts = if let Some(target_pkg) = target_pkg {
        read_package_jsons()
            .await?
            .into_iter()
            .find(|pkg| &pkg.name == target_pkg)
            .and_then(|pkg| pkg.scripts)
    } else {
        read_root_package_json().await.unwrap_or_default().scripts
    };

    let scripts = scripts
        .map(|scripts| scripts.keys().join("\n"))
        .unwrap_or_default()
        .replace(":", "\\:");
    Ok(scripts)
}
