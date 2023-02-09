#compdef pnpm

local bin_path="$(dirname $0)/target/release/pnpm-shell-completion"

_pnpm() {
    _arguments \
        '(--filter -F)'{--filter,-F}'=:flag:->filter' \
        ':command:->scripts'

    case $state in
        filter)
            if [[ -f ./pnpm-workspace.yaml ]]; then
                _values 'filter packages' $(FEATURE=filter $bin_path $words)
            fi
            ;;
        scripts)
            _values 'scripts' $(FEATURE=scripts $bin_path $words) \
                add remove rm install i update upgrade up publish
        ;;
    esac
}

compdef _pnpm pnpm
