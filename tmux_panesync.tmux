#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/scripts/helper.sh"

tmux bind-key $(user_option_or_default "@pathsync-kill-window" "BSpace") kill-window
tmux bind-key $(user_option_or_default "@pathsync-create-window" "Enter") run-shell -b "$CURRENT_DIR/scripts/tmux_cp_path.sh -w"
tmux bind-key $(user_option_or_default "@pathsync-copy-pane-path" "C") run-shell -b "$CURRENT_DIR/scripts/tmux_cp_path.sh -c"
tmux bind-key $(user_option_or_default "@pathsync-paste-pane-path" "P") run-shell -b "$CURRENT_DIR/scripts/tmux_cp_path.sh -p"
