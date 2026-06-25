# zcl completions for bash
#
# Usage: source completions/zcl.bash
#

_zcl_completions() {
  local cur prev words cword
  _init_completion || return

  local subcommands="config change-key reset update verify show-config help"
  local flags="--help --version --dry-run --verbose --safe"

  case "$prev" in
    config|change-key|set-key|change)
      # After key-setting commands, no completion needed
      return 0
      ;;
  esac

  if [[ "$cur" == -* ]]; then
    COMPREPLY=($(compgen -W "$flags" -- "$cur"))
    return 0
  fi

  # Complete subcommands
  COMPREPLY=($(compgen -W "$subcommands" -- "$cur"))
}

complete -F _zcl_completions zcl
