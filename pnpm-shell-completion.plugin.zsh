#compdef pnpm

if command -v pnpm-shell-completion &> /dev/null; then
    pnpm_comp_bin="$(which pnpm-shell-completion)"
else
    pnpm_comp_bin="$(dirname $0)/pnpm-shell-completion"
fi

_pnpm() {
    typeset -A opt_args

    _arguments \
        '(--filter -F)'{--filter,-F}'=:flag:->filter' \
        ':command:->scripts' \
        '*:: :->command_args'

    local target_pkg=${opt_args[--filter]:-$opt_args[-F]}

    case $state in
        filter)
            if [[ -f ./pnpm-workspace.yaml ]]; then
                _values 'filter packages' $(FEATURE=filter $pnpm_comp_bin)
            fi
            ;;
        scripts)
            _values 'scripts' $(FEATURE=scripts TARGET_PKG=$target_pkg ZSH=true $pnpm_comp_bin) \
                add remove install update publish
            ;;
        command_args)
            local cmd=$(FEATURE=pnpm_cmd $pnpm_comp_bin $words)
            case $cmd in
                add)
                    _arguments \
                        '(--global -g)'{--global,-g}'[Install as a global package]' \
                        '(--save-dev -D)'{--save-dev,-D}'[Save package to your `devDependencies`]' \
                        '--save-peer[Save package to your `peerDependencies` and `devDependencies`]'
                    ;;
                install|i)
                    _arguments \
                        '(--dev -D)'{--dev,-D}'[Only `devDependencies` are installed regardless of the `NODE_ENV`]' \
                        '--fix-lockfile[Fix broken lockfile entries automatically]' \
                        '--force[Force reinstall dependencies]' \
                        "--ignore-scripts[Don't run lifecycle scripts]" \
                        '--lockfile-only[Dependencies are not downloaded. Only `pnpm-lock.yaml` is updated]' \
                        '--no-optional[`optionalDependencies` are not installed]' \
                        '--offline[Trigger an error if any required dependencies are not available in local store]' \
                        '--prefer-offline[Skip staleness checks for cached data, but request missing data from the server]' \
                        '(--prod -P)'{--prod,-P}"[Packages in \`devDependencies\` won't be installed]"
                    ;;
                remove|rm|why)
                    if [[ -f ./package.json ]]; then
                        _values 'deps' $(FEATURE=deps TARGET_PKG=$target_pkg $pnpm_comp_bin)
                    fi
                    ;;
                update|upgrade|up)
                    _arguments \
                        '(--dev -D)'{--dev,-D}'[Update packages only in "devDependencies"]' \
                        '(--global -g)'{--global,-g}'[Update globally installed packages]' \
                        '(--interactive -i)'{--interactive,-i}'[Show outdated dependencies and select which ones to update]' \
                        '(--latest -L)'{--latest,-L}'[Ignore version ranges in package.json]' \
                        "--no-optional[Don't update packages in \`optionalDependencies\`]" \
                        '(--prod -P)'{--prod,-P}'[Update packages only in "dependencies" and "optionalDependencies"]' \
                        '(--recursive -r)'{--recursive,-r}'[Update in every package found in subdirectories or every workspace package]'
                    if [[ -f ./package.json ]]; then
                        _values 'deps' $(FEATURE=deps TARGET_PKG=$target_pkg $pnpm_comp_bin)
                    fi
                    ;;
                publish)
                    _arguments \
                        '--access=[Tells the registry whether this package should be published as public or restricted]: :(public restricted)' \
                        '--dry-run[Does everything a publish would do except actually publishing to the registry]' \
                        '--force[Packages are proceeded to be published even if their current version is already in the registry]' \
                        '--ignore-scripts[Ignores any publish related lifecycle scripts (prepublishOnly, postpublish, and the like)]' \
                        "--no-git-checks[Don't check if current branch is your publish branch, clean, and up to date]" \
                        '--otp[Specify a one-time password]' \
                        '--publish-branch[Sets branch name to publish]' \
                        '(--recursive -r)'{--recursive,-r}'[Publish all packages from the workspace]' \
                        '--tag=[Registers the published package with the given tag]'
                    ;;
                run)
                    if [[ -f ./package.json ]]; then
                        _values 'scripts' $(FEATURE=scripts TARGET_PKG=$target_pkg ZSH=true $pnpm_comp_bin)
                    fi
                    ;;
                *)
                    _files
            esac
    esac
}

compdef _pnpm pnpm
