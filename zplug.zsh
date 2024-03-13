#!/usr/bin/env zsh
set -e

local version=$(grep '^version =' Cargo.toml | cut -d'"' -f2)

if [ $(uname) = "Darwin" ]; then
    if [ $(uname -m) = "arm64" ]; then
        target="aarch64-apple-darwin"
    else
        target="x86_64-apple-darwin"
    fi
else
    target="x86_64-unknown-linux-musl"
fi

local url="https://github.com/g-plane/pnpm-shell-completion/releases/download/v$version/pnpm-shell-completion_$target.zip"

if [ $(hash wget 2>/dev/null) ]; then
    wget $url > zipball.zip
else
    curl -fsSL $url -o zipball.zip
fi

unzip zipball.zip pnpm-shell-completion
rm zipball.zip
