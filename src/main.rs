mod filter;
mod monorepo;
mod types;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    println!("{}", filter::provide_packages_candidate().await?);
    Ok(())
}
