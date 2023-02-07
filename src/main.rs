use std::env;

mod filter;
mod monorepo;
mod scripts;
mod types;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let args = env::args().collect::<Vec<_>>();
    if matches!(
        args.last().map(|s| s.strip_suffix('=').unwrap_or(&s)),
        Some("--filter" | "-F")
    ) {
        println!("{}", filter::provide_packages_candidate().await?);
        return Ok(());
    }

    println!(
        "{}",
        scripts::provide_scripts_candidate(monorepo::pick_target_pkg(&args)).await?
    );

    Ok(())
}
