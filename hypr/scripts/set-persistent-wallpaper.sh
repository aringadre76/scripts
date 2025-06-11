#!/bin/bash
#
# Set a persistent wallpaper that won't be overwritten on reboot
#

# Check if a wallpaper path is provided
if [ $# -eq 0 ]; then
    echo "Error: Please provide the path to a wallpaper image."
    echo "Usage: $0 /path/to/wallpaper.jpg"
    exit 1
fi

wallpaper="$1"

# Check if the wallpaper file exists
if [ ! -f "$wallpaper" ]; then
    echo "Error: The file '$wallpaper' does not exist."
    exit 1
fi

# Create the settings directory if it doesn't exist
mkdir -p "$HOME/.config/ml4w/settings"

# Save the wallpaper path to the persistent wallpaper file
echo "$wallpaper" > "$HOME/.config/ml4w/settings/persistent_wallpaper"

# Also update the current wallpaper cache
echo "$wallpaper" > "$HOME/.config/ml4w/cache/current_wallpaper"

# Generate colorscheme with pywal16 and apply wallpaper via swww
wal -i "$wallpaper" --saturate 0.5
# Ensure swww-daemon is running
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    sleep 0.2
fi
# Apply the wallpaper
swww img "$wallpaper" --transition-fps 60 --transition-type wipe --transition-duration 2

echo "Persistent wallpaper set to: $wallpaper"
echo "This wallpaper will be used even after rebooting." 