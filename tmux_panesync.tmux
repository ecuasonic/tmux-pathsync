#!/usr/bin/env bash

# Source utils.sh
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/scripts/utils.sh"

MAIN_SCRIPT="$CURRENT_DIR/scripts/main.sh"

# Default keybindings for pathsync options.
bspace_command=$(user_option_or_default "@pathsync-kill-window" "BSpace")
enter_command=$(user_option_or_default "@pathsync-create-window" "Enter")
c_command=$(user_option_or_default "@pathsync-copy-pane-path" "c")
p_command=$(user_option_or_default "@pathsync-paste-pane-path" "p")

tmux bind-key "$bspace_command" kill-window
tmux bind-key "$enter_command" run-shell -b "$MAIN_SCRIPT -w"
tmux bind-key "$c_command" run-shell -b "$MAIN_SCRIPT -c"
tmux bind-key "$p_command" run-shell -b "$MAIN_SCRIPT -p"
