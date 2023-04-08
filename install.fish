if not set -q argv[1]
    echo "Plugins directory not specified, please pass your zsh plugins directory as a parameter."
    exit 1
end

if test -d $argv[1]
    mkdir -p ~/.config/fish/completions/
    cp ./pnpm-shell-completion.fish ~/.config/fish/completions/pnpm.fish
    cp ./pnpm-shell-completion $argv[1]
else
    echo "$argv[1] is not exist"
end

