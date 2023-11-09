# pnpm-shell-completion

https://user-images.githubusercontent.com/17216317/218267283-ac16f583-506e-473f-9efc-e25095e38504.mp4

or

[![asciicast](https://asciinema.org/a/559081.svg)](https://asciinema.org/a/559081)

**fish**

https://user-images.githubusercontent.com/17974631/230724177-c23eb38c-6112-49f8-8091-54c68a074739.webm

_You may also like:_

- [icd](https://github.com/g-plane/icd) - Powerful `cd` command with fuzzy-search tool.

## Features

- Provide completion for `pnpm --filter <package>`.
- Provide completion for `pnpm remove` command, even in workspace's packages (by specifying `--filter` option).
- Provide completion for npm scripts in `package.json`.

### Limitiation

- Note that we won't provide completion for all commands and options, and we only focus those frequently used. Too many completion items may have impact on efficiency.
- NPM scripts completion requires the presence of a `name` property in the `package.json` file.

### Supported shells

- Zsh
- PowerShell Core
- Fish Shell

## Installation

### [zinit](https://github.com/zdharma/zinit)

Update your `.zshrc` file with the following line:

```zsh
zinit ice atload"zpcdreplay" atclone"./zplug.zsh" atpull"%atclone"
zinit light g-plane/pnpm-shell-completion
```

### [zplug](https://github.com/zplug/zplug)

Update your `.zshrc` file with the following line:

```zsh
zplug "g-plane/pnpm-shell-completion", hook-build:"./zplug.zsh", defer:2
```

### Arch Linux

Install it with any AUR helper, for example:

```shell
paru -S pnpm-shell-completion
```

Then, update your `.zshrc` file with the following line:

```shell
source /usr/share/zsh/plugins/pnpm-shell-completion/pnpm-shell-completion.zsh
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

### PowerShell Core

Please go to the [GitHub releases](https://github.com/g-plane/pnpm-shell-completion/releases)
page and download `pnpm-shell-completion_x86_64-pc-windows-gnu.zip`, then decompress it.

Edit your PowerShell profile file (if you don't know where it is, run `echo $PROFILE` to check it),
and add the following line:

```powershell
. path\to\the\directory\you\decompressed\pnpm-shell-completion.ps1
```

### Fish

#### [Fisher](https://github.com/jorgebucaran/fisher)

```
fisher install g-plane/pnpm-shell-completion
```

#### Manual Install

Please go to the [GitHub releases](https://github.com/g-plane/pnpm-shell-completion/releases)
page and download the latest binary files.

For Apple Silicon (M-series chips) users, please choose `aarch64-apple-darwin`;
for Intel Mac users, please choose `x86_64-apple-darwin`;
for Linux users, please choose `x86_64-unknown-linux-gnu` or `x86_64-unknown-linux-musl`.

After downloaded, decompress the `.zip` or `.tar.gz` file.

Then, run:

```shell
fish ./install.fish ${any path that has been added in your $PATH variable}
```

By default, `pnpm.fish` will be copied to your `~/.config/fish/completions/` according to the [official documentation](https://fishshell.com/docs/current/completions.html).

## License

MIT License

Copyright (c) 2023-present Pig Fang
