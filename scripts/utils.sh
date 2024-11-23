#!/usr/bin/env bash

#######################################
# Take user keybind or use default.
# Arguments:
#   $1: Command Option
#   $2: User Keybind
#######################################
function user_option_or_default() {
    local option
    option="$(tmux show-option -gvq "$1")"
    if [[ -z $option ]]; then
        option="$2"
    fi
    echo "$option"
}

#######################################
# Display help message if
# main function used directly
# and incorrectly.
#######################################
function msg() {
    echo    "
    Must have only one of the following flags:
    create-window   : -w
    copy-pane-path  : -c
    paste-pane-path : -p
    "
}
