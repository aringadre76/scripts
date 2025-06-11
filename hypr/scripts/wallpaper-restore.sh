#!/bin/bash
#                _ _
# __      ____ _| | |_ __   __ _ _ __   ___ _ __
# \ \ /\ / / _` | | | '_ \ / _` | '_ \ / _ \ '__|
#  \ V  V / (_| | | | |_) | (_| | |_) |  __/ |
#   \_/\_/ \__,_|_|_| .__/ \__,_| .__/ \___|_|
#                   |_|         |_|
#
# -----------------------------------------------------
# Restore last wallpaper and Pywal colors
# -----------------------------------------------------

# Initialize swww-daemon if not already running
if ! pgrep -x "swww-daemon" > /dev/null; then
    # Start the swww wallpaper daemon in the background
    swww-daemon &
    # Give it a moment to initialize
    sleep 0.2
fi

# -----------------------------------------------------
# Set defaults
# -----------------------------------------------------

defaultwallpaper="$HOME/wallpaper/default.jpg"
persistentcachefile="$HOME/.config/ml4w/settings/persistent_wallpaper"
cachefile="$HOME/.config/ml4w/cache/current_wallpaper"

# -----------------------------------------------------
# Get current wallpaper
# -----------------------------------------------------

# First check if there's a persistent wallpaper preference
if [ -f "$persistentcachefile" ]; then
    sed -i "s|~|$HOME|g" "$persistentcachefile"
    wallpaper=$(cat $persistentcachefile)
    if [ -f $wallpaper ]; then
        echo ":: Using persistent wallpaper $wallpaper"
        # Update the regular cache file so other things know about our wallpaper
        echo "$wallpaper" > "$cachefile"
    else
        echo ":: Persistent wallpaper $wallpaper does not exist. Falling back to cache."
        # Fall back to cache file
        if [ -f "$cachefile" ]; then
            sed -i "s|~|$HOME|g" "$cachefile"
            wallpaper=$(cat $cachefile)
            if [ -f $wallpaper ]; then
                echo ":: Wallpaper $wallpaper exists"
            else
                echo ":: Wallpaper $wallpaper does not exist. Using default."
                wallpaper=$defaultwallpaper
            fi
        else
            echo ":: $cachefile does not exist. Using default wallpaper."
            wallpaper=$defaultwallpaper
        fi
    fi
elif [ -f "$cachefile" ]; then
    sed -i "s|~|$HOME|g" "$cachefile"
    wallpaper=$(cat $cachefile)
    if [ -f $wallpaper ]; then
        echo ":: Wallpaper $wallpaper exists"
    else
        echo ":: Wallpaper $wallpaper does not exist. Using default."
        wallpaper=$defaultwallpaper
    fi
else
    echo ":: $cachefile does not exist. Using default wallpaper."
    wallpaper=$defaultwallpaper
fi

# -----------------------------------------------------
# Set wallpaper and generate Pywal colors
# -----------------------------------------------------

echo ":: Setting wallpaper and generating colors with source image $wallpaper"
# Use pywal16 instead of system pywal
$HOME/.local/bin/wal -i "$wallpaper" --saturate 0.5

# Check which wallpaper engine is configured
wallpaper_engine_file="$HOME/.config/ml4w/settings/wallpaper-engine.sh"
if [ -f "$wallpaper_engine_file" ]; then
    wallpaper_engine=$(cat "$wallpaper_engine_file")
else
    # Default to swww if no config file exists
    wallpaper_engine="swww"
fi

# Apply wallpaper based on configured engine
if [ "$wallpaper_engine" == "swww" ]; then
    echo ":: Using swww to set wallpaper"
    swww img "$wallpaper" --transition-fps 60 --transition-type wipe --transition-duration 2
elif [ "$wallpaper_engine" == "hyprpaper" ]; then
    echo ":: Using waypaper with hyprpaper backend to set wallpaper"
    waypaper --backend hyprpaper --wallpaper "$wallpaper"
else
    # Use the main wallpaper script as a fallback
    echo ":: Using main wallpaper script to set wallpaper"
    $HOME/.config/hypr/scripts/wallpaper.sh "$wallpaper"
fi
