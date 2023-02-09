use itertools::Itertools;

pub fn extract_pnpm_cmd(args: &[String]) -> Option<&String> {
    if let Some((i, _)) = args
        .iter()
        .find_position(|arg| *arg == "--filter" || *arg == "-F")
    {
        args.get(i + 2)
    } else if let Some((i, _)) = args
        .iter()
        .find_position(|arg| arg.starts_with("--filter=") || arg.starts_with("-F="))
    {
        args.get(i + 1)
    } else {
        args.get(1)
    }
}
