use crate::monorepo::{read_package_jsons, read_root_package_json};
use itertools::Itertools;

pub async fn provide_deps_candidate(target_pkg: Option<&str>) -> anyhow::Result<String> {
    let manifest = if let Some(target_pkg) = target_pkg {
        read_package_jsons()
            .await?
            .into_iter()
            .find(|pkg| &pkg.name == target_pkg)
    } else {
        read_root_package_json().await.ok()
    };

    let output = manifest.map(|manifest| {
        manifest
            .dependencies
            .iter()
            .flat_map(|deps| deps.keys())
            .chain(
                manifest
                    .dev_dependencies
                    .iter()
                    .flat_map(|dev_deps| dev_deps.keys()),
            )
            .chain(
                manifest
                    .peer_dependencies
                    .iter()
                    .flat_map(|peer_deps| peer_deps.keys()),
            )
            .join("\n")
    });

    Ok(output.unwrap_or_default())
}
