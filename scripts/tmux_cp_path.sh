#!/usr/bin/env bash

COPY_BUFFER="/tmp/tmux_pane_path_copy_buffer.txt"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $CURRENT_DIR/helper.sh

mesg() {
    echo    "
    Must have only one of the following flags:
    create-window   : -w
    copy-pane-path  : -c
    paste-pane-path : -p
    "
}

main() {
    if (( $# != 1 )); then
        mesg
        exit 1
    fi

    # If file doesn't exist:
    if [[ ! -e "$COPY_BUFFER" ]]; then
        touch $COPY_BUFFER
    fi

    while getopts "wpc" option; do
        case $option in
            p)
                # Pane Paste Mechanism (Clear):
                if [[ -s "$COPY_BUFFER" ]]; then
                    tmux respawn-pane -c "$(cat $COPY_BUFFER)" -k
                    rm $COPY_BUFFER; touch $COPY_BUFFER
                else
                    tmux respawn-pane -c "#{pane_current_path}" -k
                fi
                ;;
            c)
                # Copy Mechanism (Overwrite):
                tmux display -p "#{pane_current_path}" > $COPY_BUFFER
                ;;
            w)
                # Window Paste Mechanism (Clear):
                if [[ -s "$COPY_BUFFER" ]]; then
                    tmux new-window -c "$(cat $COPY_BUFFER)"
                    rm $COPY_BUFFER; touch $COPY_BUFFER
                else
                    tmux new-window -c "$HOME"
                fi
                tmux run-shell -b $(user_option_or_default "@pathsync-new-window-layout-path" "$CURRENT_DIR/tmux_layout.sh")
                ;;
            ?/)
                mesg
                exit 1
                ;;
        esac
    done
}

main $1
