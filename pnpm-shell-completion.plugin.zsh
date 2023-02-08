#compdef pnpm

local bin_path="$(dirname $0)/target/release/pnpm-shell-completion"

_pnpm() {
    _arguments \
        '(--filter -F)'{--filter,-F}'=:flag:->filter' \
        ':command:->scripts'

    case $state in
        filter)
            _values 'filter packages' $(FEATURE=filter $bin_path $words)
            ;;
        scripts)
            _values 'scripts' $(FEATURE=scripts $bin_path $words) add remove rm
        ;;
    esac
}

compdef _pnpm pnpm
