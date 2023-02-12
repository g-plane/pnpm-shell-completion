# pnpm-shell-completion

https://user-images.githubusercontent.com/17216317/218267283-ac16f583-506e-473f-9efc-e25095e38504.mp4

or

[![asciicast](https://asciinema.org/a/559081.svg)](https://asciinema.org/a/559081)

Currently only Zsh is supported.

_You may also like:_

- [icd](https://github.com/g-plane/icd) - Powerful `cd` command with fuzzy-search tool.

## Features

- Provide completion for `pnpm --filter <package>`.
- Provide completion for `pnpm remove` command, even in workspace's packages (by specifying `--filter` option).
- Provide completion for npm scripts in `package.json`.

Note that we won't provide completion for all commands and options,
and we only focus those frequently used.
Too many completion items may have impact on efficiency.

## Installation

### With a plugin manager

#### [zinit](https://github.com/zdharma/zinit)

Update your `.zshrc` file with the following line:

```zsh
zinit ice atload"zpcdreplay" atclone"./zplug.zsh"
zinit light g-plane/pnpm-shell-completion
```

#### [zplug](https://github.com/zplug/zplug)

Update your `.zshrc` file with the following line:

```zsh
zplug "g-plane/pnpm-shell-completion", hook-build:"./zplug.zsh", defer:2
```

### Oh My Zsh

Please go to the [GitHub releases](https://github.com/g-plane/pnpm-shell-completion/releases)
page and download the latest binary files.

For Apple Silicon (M-series chips) users, please choose `aarch64-apple-darwin`;
for Intel Mac users, please choose `x86_64-apple-darwin`;
for Linux users, please choose `x86_64-unknown-linux-gnu` or `x86_64-unknown-linux-musl`.

After downloaded, decompress the `.zip` or `.tar.gz` file.

Then, run:

```shell
./install.zsh $ZSH_CUSTOM/plugins
```

Next, please edit your `.zshrc` file.
Add `pnpm-shell-completion` to `plugins` section like this:

```diff
plugins=(
  # ... your other plugins
+ pnpm-shell-completion
)
```

Restart your terminal.

## License

MIT License

Copyright (c) 2023-present Pig Fang
