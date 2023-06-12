use crate::monorepo::{read_package_jsons, read_root_package_json};
use itertools::Itertools;
use std::env;

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

    let mut scripts = scripts
        .map(|scripts| scripts.keys().join("\n"))
        .unwrap_or_default();
    // #8: escape colons for Zsh
    // this variable is set in "pnpm-shell-completion.plugin.zsh"
    if env::var("ZSH").is_ok() {
        scripts = scripts.replace(':', "\\:");
    }
    Ok(scripts)
}
