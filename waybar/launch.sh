#!/bin/bash
#      _                     _
#  ___| | ___  __ _ _ __   | | ___  
# / __| |/ _ \/ _` | '_ \  | |/ _ \ 
# \__ \ |  __/ (_| | | | | | | (_) |
# |___/_|\___|\__,_|_| |_| |_|\___/ 
#                                  
# by Stephan Raabe (2023)
# -----------------------------------------------------

# Kill already running processes
killall waybar

# Default theme
CONFIG="$HOME/.config/waybar/themes/sugoi/config"
STYLE="$HOME/.config/waybar/themes/sugoi/style.css"

# Wait for waybar to close
sleep 0.5

# Ensure Wayland backend
export GDK_BACKEND=wayland
export QT_QPA_PLATFORM=wayland

# Start waybar
waybar -c $CONFIG -s $STYLE
