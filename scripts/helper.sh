#!/usr/bin/env bash

user_option_or_default() {
    local option
    option="$(tmux show-option -gvq "$1")"
    if [[ -z $option ]]; then
        option="$2"
    fi
    echo "$option"
}
