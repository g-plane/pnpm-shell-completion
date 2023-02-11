set -x

if [ -z "$1" ]; then
    echo "Plugins directory not specified, please pass your zsh plugins directory as a parameter."
    exit 1
fi

if [ ! -d $1/pnpm-shell-completion ]; then
    mkdir $1/pnpm-shell-completion
fi

cp ./pnpm-shell-completion.plugin.zsh $1/pnpm-shell-completion
cp ./pnpm-shell-completion $1/pnpm-shell-completion
