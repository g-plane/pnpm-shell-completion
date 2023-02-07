use crate::{monorepo::read_package_jsons, types::PackageJson};
use itertools::Itertools;

pub async fn provide_packages_candidate() -> anyhow::Result<String> {
    let names = read_package_jsons()
        .await?
        .into_iter()
        .map(|PackageJson { name, .. }| name)
        .join("\n");
    Ok(names)
}
