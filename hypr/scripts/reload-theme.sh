#!/bin/bash

# Reload Waybar
pkill waybar
~/.config/waybar/launch.sh &

# Reload Hyprland colors
cp ~/.cache/wal/colors-hyprland.conf ~/.config/hypr/colors.conf
hyprctl reload

# Reload notifications
pkill swaync
swaync &

# Set the wallpaper
swww img ~/.cache/wal/wallpaper.jpg --transition-fps 60 --transition-type wipe --transition-duration 2

# Notify
notify-send "Theme Reloaded" "Applied new color scheme!" 