#compdef pnpm

local bin_path="$(dirname $0)/target/release/pnpm-shell-completion"

_pnpm() {
	_arguments '(--filter -F)'{--filter,-F}'=:flag:->filter'

	case $state in
		filter)
			_values 'filter packages' $($bin_path)
			;;
	esac
}

compdef _pnpm pnpm
