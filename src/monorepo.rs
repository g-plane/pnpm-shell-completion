use crate::types::PackageJson;
use futures::future::join_all;
use globset::{GlobBuilder, GlobSet, GlobSetBuilder};
use serde::Deserialize;
use std::{env, path::PathBuf};
use tokio::{fs, task::JoinError};
use walkdir::WalkDir;

#[derive(Default, Deserialize)]
struct PnpmWorkspace<'s> {
    #[serde(borrow)]
    packages: Vec<&'s str>,
}

pub async fn read_root_package_json() -> anyhow::Result<PackageJson> {
    let json = fs::read_to_string(
        env::current_dir()
            .unwrap_or_else(|_| PathBuf::from("."))
            .join("package.json"),
    )
    .await;
    serde_json::from_str(json.as_deref().unwrap_or("{}")).map_err(anyhow::Error::from)
}

pub async fn read_package_jsons() -> anyhow::Result<Vec<PackageJson>> {
    let globs = read_workspace_config().await?;
    let jsons = join_all(
        scan_directories(globs)
            .await?
            .into_iter()
            .map(|path| async {
                serde_json::from_str::<PackageJson>(
                    &fs::read_to_string(path).await.unwrap_or_default(),
                )
                .unwrap_or_default()
            }),
    )
    .await;
    Ok(jsons)
}

async fn scan_directories(globs: GlobSet) -> Result<Vec<PathBuf>, JoinError> {
    tokio::task::spawn_blocking(move || {
        let base_dir = env::current_dir().unwrap_or_else(|_| PathBuf::from("."));
        WalkDir::new(&base_dir)
            .into_iter()
            .map(|entry| entry.map(|entry| entry.into_path()))
            .filter(|path| {
                path.as_ref()
                    .ok()
                    .and_then(|path| path.strip_prefix(&base_dir).ok())
                    .map(|path| globs.is_match(path))
                    .unwrap_or_default()
            })
            .map(|path| path.map(|path| path.join("package.json")))
            .collect::<Result<Vec<_>, _>>()
            .unwrap_or_default()
    })
    .await
}

async fn read_workspace_config() -> Result<GlobSet, globset::Error> {
    let yaml = fs::read_to_string(
        env::current_dir()
            .map(|path| path.join("pnpm-workspace.yaml"))
            .unwrap_or_else(|_| PathBuf::from("./pnpm-workspace.yaml")),
    )
    .await
    .unwrap_or_default();

    build_glob_set(
        &serde_yaml::from_str::<PnpmWorkspace>(&yaml)
            .unwrap_or_default()
            .packages,
    )
}

fn build_glob_set(globs: &[&str]) -> Result<GlobSet, globset::Error> {
    globs
        .iter()
        .try_fold(GlobSetBuilder::new(), |mut globset_builder, glob| {
            let mut glob_builder = GlobBuilder::new(&glob);
            glob_builder.literal_separator(true);
            globset_builder.add(glob_builder.build()?);
            Ok(globset_builder)
        })?
        .build()
}
