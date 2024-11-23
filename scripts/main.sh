#!/usr/bin/env bash

# Copy name of path into temporary file.
COPY_BUFFER="/tmp/tmux_pane_path_copy_buffer.txt"

# Get user_option_or_default from helper.sh
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR"/utils.sh

#######################################
# Main Function
#######################################
function main() {
    if (( $# != 1 )); then
        msg
        exit 1
    fi

    # Create temp file if not already.
    if [ ! -f "$COPY_BUFFER" ]; then
        touch $COPY_BUFFER
    fi

    while getopts "wpc" option; do
        case $option in
            p)
                # Paste Pane Path Mechanism (Clears path):
                pane_path=$( ([ -s "$COPY_BUFFER" ] && cat "$COPY_BUFFER") \
                    || echo "#{pane_current_path}" )

                tmux respawn-pane -c "$pane_path" -k >/dev/null 2>/dev/null
                : > "$COPY_BUFFER"
                ;;

            c)
                # Copy Pane Path Mechanism (Overwrites path):
                tmux display -p "#{pane_current_path}" > $COPY_BUFFER
                ;;

            w)
                # Window Paste Mechanism (Clears path):
                window_path=$( ([ -s "$COPY_BUFFER" ] && cat "$COPY_BUFFER") \
                    || echo "$HOME" )

                tmux new-window -c "$window_path"
                : > "$COPY_BUFFER"

                window_layout_command=$(user_option_or_default \
                    "@pathsync-new-window-layout-path" \
                    "$CURRENT_DIR/default_window_layout.sh")
                tmux run-shell -b "$window_layout_command"
                ;;
            ?/)
                msg
                exit 1
                ;;
        esac
    done
}

main "$1"
