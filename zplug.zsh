#!/usr/bin/zsh
set -e

local version=$(grep '^version =' Cargo.toml | cut -d'"' -f2)

if [ $(uname) = "Darwin" ]; then
    platform="macos"
else
    platform="ubuntu"
fi

local url="https://github.com/g-plane/pnpm-shell-completion/releases/download/v$version/pnpm-shell-completion_$platform-latest.zip"

if [ $(hash wget 2>/dev/null) ]; then
    wget $url > zipball.zip
else
    curl -fsSL $url -o zipball.zip
fi

unzip zipball.zip pnpm-shell-completion
rm zipball.zip
