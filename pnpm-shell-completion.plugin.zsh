#compdef pnpm

local bin_path="$(dirname $0)/target/release/pnpm-shell-completion"

_pnpm() {
	_arguments \
		'(--filter -F)'{--filter,-F}'=:flag:->filter' \
		':command:->scripts'

	case $state in
		filter)
			_values 'filter packages' $($bin_path $words)
			;;
		scripts)
			_values 'scripts' $($bin_path $words) add rm
        ;;
	esac
}

compdef _pnpm pnpm
