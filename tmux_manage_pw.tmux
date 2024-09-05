#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

tmux bind-key Enter run-shell -b "$CURRENT_DIR/scripts/tmux_cp_path.sh -w"
tmux bind-key p run-shell -b "$CURRENT_DIR/scripts/tmux_cp_path.sh -p"
tmux bind-key c run-shell -b "$CURRENT_DIR/scripts/tmux_cp_path.sh -c"
bind-key BSpace kill-window
