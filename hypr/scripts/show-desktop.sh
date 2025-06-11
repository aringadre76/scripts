#!/bin/bash

# Get the current state from a temporary file
STATE_FILE="/tmp/hypr_desktop_state"

if [ ! -f "$STATE_FILE" ]; then
    echo "show" > "$STATE_FILE"
fi

current_state=$(cat "$STATE_FILE")

if [ "$current_state" = "show" ]; then
    # Hide all windows
    notify-send "Desktop" "Hiding windows..."
    hyprctl dispatch workspace special:hide
    echo "hide" > "$STATE_FILE"
else
    # Show all windows
    notify-send "Desktop" "Showing windows..."
    hyprctl dispatch workspace previous
    echo "show" > "$STATE_FILE"
fi 