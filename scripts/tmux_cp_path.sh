#!/usr/bin/env bash

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

    COPY_BUFFER="/tmp/tmux_pane_path_copy_buffer.txt"
    CURRENT_PATH=$(dirname $BASH_SOURCE)

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
                    tmux run-shell -b "$CURRENT_PATH/tmux_layout.sh"
                else
                    tmux new-window -c "$HOME"
                    tmux run-shell -b "$CURRENT_PATH/tmux_layout.sh"
                fi

                ;;
            ?/)
                mesg
                exit 1
                ;;
        esac
    done
}

main $1
