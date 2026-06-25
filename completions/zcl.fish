# zcl completions for fish
#
# Usage: source completions/zcl.fish
#   Or copy to ~/.config/fish/completions/

complete -c zcl -f

# Flags
complete -c zcl -l help    -d 'Show help message'
complete -c zcl -l version -d 'Show version number'
complete -c zcl -l dry-run -d 'Print what would be executed'
complete -c zcl -l verbose -d 'Print debug information'
complete -c zcl -l safe    -d 'Run without --dangerously-skip-permissions'

# Subcommands
complete -c zcl -a config      -d 'Set or change the stored API key'
complete -c zcl -a change-key  -d 'Alias for config'
complete -c zcl -a reset       -d 'Delete the stored API key'
complete -c zcl -a update      -d 'Update to the latest version'
complete -c zcl -a verify      -d 'Verify the stored API key'
complete -c zcl -a show-config -d 'Print current configuration'
complete -c zcl -a help        -d 'Show help message'
