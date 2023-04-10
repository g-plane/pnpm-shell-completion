set -g filter_flag

set -g __fish_pnpm_cmdline
set -g __fish_pnpm_remove_cmdline

complete -c pnpm -f
complete -c pnpm -n "not __fish_seen_subcommand_from remove" -a "(__get_scripts)"
complete -c pnpm -f -l filter -s F -r -a "$(FEATURE=filter pnpm-shell-completion)"
# add relative args
complete -c pnpm -n "not __fish_use_subcommand" -f -a "add"
complete -c pnpm -n __could_add_global -l global -s g
complete -c pnpm -n "__fish_seen_subcommand_from add" -l save-dev -s D
complete -c pnpm -n "__fish_seen_subcommand_from add" -l save-peer
complete -c pnpm -n "__fish_seen_subcommand_from remove" -f -a "(__get_deps)"

function __get_scripts
  set -l cmdline (commandline -c)
  if set -q __fish_pnpm_cmdline; and test "$cmdline" = "$__fish_pnpm_cmdline"
    return 0
  end

  set -g __fish_pnpm_cmdline $cmdline

  set -l tokens (commandline -opc)
  set -e tokens[1] # assume the first token is `pnpm`
  argparse 'F/filter=' -- $tokens 2>/dev/null
  TARGET_PKG=$_flag_filter FEATURE=scripts pnpm-shell-completion
end

function __get_deps
  set -l cmdline (commandline -c)
  if set -q __fish_pnpm_remove_cmdline; and test "$cmdline" = "$__fish_pnpm_remove_cmdline"
    return 0
  end

  set -g __fish_pnpm_remove_cmdline $cmdline

  set -l tokens (commandline -opc)
  set -e tokens[1] # assume the first token is `pnpm`
  argparse 'F/filter=' -- $tokens 2>/dev/null
  TARGET_PKG=$_flag_filter FEATURE=deps pnpm-shell-completion
end

function __has_filter
  set -l tokens (commandline -opc)
  set -e tokens[1] # assume the first token is `pnpm`
  argparse 'F/filter=' -- $tokens 2>/dev/null
  if count $_flag_filter == 0
    return 1
  end
  return 0
end

# predicate function, 1 means false, 0 means true
function __could_add_global
  if __has_filter == 0
    return 1
  end
  if __fish_seen_subcommand_from add == 0
    return 0
  end
  return 1
end
