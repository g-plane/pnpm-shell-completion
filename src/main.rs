use std::env;

mod filter;
mod monorepo;
mod scripts;
mod types;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let args = env::args().collect::<Vec<_>>();

    match env::var("FEATURE").as_deref() {
        Ok("filter") => println!("{}", filter::provide_packages_candidate().await?),
        Ok("scripts") => println!(
            "{}",
            scripts::provide_scripts_candidate(monorepo::pick_target_pkg(&args)).await?
        ),
        _ => {}
    }

    Ok(())
}
