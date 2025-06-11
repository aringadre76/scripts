#!/bin/bash

# Get the current state from a temporary file
STATE_FILE="/tmp/hypr_desktop_state"

if [ ! -f "$STATE_FILE" ]; then
    echo "0" > "$STATE_FILE"
fi

current_state=$(cat "$STATE_FILE")

if [ "$current_state" == "0" ]; then
    # Hide all windows
    hyprctl dispatch workspace special:minimized
    echo "1" > "$STATE_FILE"
else
    # Restore all windows
    hyprctl dispatch workspace previous
    echo "0" > "$STATE_FILE"
fi 