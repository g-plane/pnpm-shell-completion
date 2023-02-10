use std::env;

mod deps;
mod filter;
mod monorepo;
mod pnpm_cmd;
mod scripts;
mod types;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let args = env::args().collect::<Vec<_>>();
    let target_pkg = env::var("TARGET_PKG")
        .map(|s| s.trim().to_owned())
        .ok()
        .and_then(|value| (!value.is_empty()).then_some(value));

    match env::var("FEATURE").as_deref() {
        Ok("filter") => println!("{}", filter::provide_packages_candidate().await?),
        Ok("scripts") => println!(
            "{}",
            scripts::provide_scripts_candidate(target_pkg.as_deref()).await?
        ),
        Ok("deps") => println!(
            "{}",
            deps::provide_deps_candidate(target_pkg.as_deref()).await?
        ),
        Ok("pnpm_cmd") => {
            if let Some(cmd) = pnpm_cmd::extract_pnpm_cmd(&args) {
                print!("{cmd}");
            }
        }
        _ => {}
    }

    Ok(())
}
