#!/bin/bash

# Startup wallpaper and theme restoration script
# This script gets the current wallpaper from waypaper config and applies the theme

echo ":: Starting wallpaper and theme restoration..."

# Wait for the system to be more ready before proceeding
echo ":: Waiting for system to be ready..."
sleep 5

# Wait for Hyprland to be fully loaded
while ! hyprctl version >/dev/null 2>&1; do
    echo ":: Waiting for Hyprland to be ready..."
    sleep 1
done

echo ":: Hyprland is ready, proceeding with wallpaper restoration..."

# Get the current wallpaper from waypaper config
waypaper_config="$HOME/.config/waypaper/config.ini"
current_wallpaper=""

if [ -f "$waypaper_config" ]; then
    # Extract wallpaper path from waypaper config
    current_wallpaper=$(grep "^wallpaper = " "$waypaper_config" | cut -d' ' -f3)
    # Expand ~ to full path
    current_wallpaper="${current_wallpaper/#\~/$HOME}"
    echo ":: Found wallpaper in config: $current_wallpaper"
else
    echo ":: Waypaper config not found, using fallback"
fi

# Fallback: check cache files
if [ -z "$current_wallpaper" ] || [ ! -f "$current_wallpaper" ]; then
    echo ":: Checking cache files for wallpaper..."
    
    # Check ML4W cache files
    if [ -f "$HOME/.config/ml4w/cache/current_wallpaper" ]; then
        current_wallpaper=$(cat "$HOME/.config/ml4w/cache/current_wallpaper")
        echo ":: Found wallpaper in ML4W cache: $current_wallpaper"
    elif [ -f "$HOME/.cache/current_wallpaper" ]; then
        current_wallpaper=$(cat "$HOME/.cache/current_wallpaper")
        echo ":: Found wallpaper in cache: $current_wallpaper"
    fi
fi

# Final fallback: use default wallpaper
if [ -z "$current_wallpaper" ] || [ ! -f "$current_wallpaper" ]; then
    echo ":: No valid wallpaper found, looking for default..."
    
    # Look for any wallpaper in the wallpaper directory
    if [ -d "$HOME/wallpaper" ]; then
        current_wallpaper=$(find "$HOME/wallpaper" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | head -1)
        if [ -n "$current_wallpaper" ]; then
            echo ":: Using first available wallpaper: $current_wallpaper"
        fi
    fi
    
    # If still no wallpaper found, try common locations
    if [ -z "$current_wallpaper" ] || [ ! -f "$current_wallpaper" ]; then
        for default_path in "$HOME/wallpaper/default.jpg" "$HOME/Pictures/wallpaper.jpg" "/usr/share/pixmaps/default.jpg"; do
            if [ -f "$default_path" ]; then
                current_wallpaper="$default_path"
                echo ":: Using default wallpaper: $current_wallpaper"
                break
            fi
        done
    fi
fi

# Check if we have a valid wallpaper
if [ -z "$current_wallpaper" ] || [ ! -f "$current_wallpaper" ]; then
    echo ":: Error: No valid wallpaper found!"
    notify-send "Wallpaper Error" "No valid wallpaper found for startup restoration" 2>/dev/null
    exit 1
fi

echo ":: Using wallpaper: $current_wallpaper"

# Use waypaper to set the wallpaper (this will also trigger the theme update via post_command)
echo ":: Setting wallpaper via waypaper..."
if waypaper --wallpaper "$current_wallpaper" >/dev/null 2>&1; then
    echo ":: Wallpaper set successfully!"
    notify-send "Wallpaper Restored" "Startup wallpaper and theme restoration complete" 2>/dev/null
else
    echo ":: Waypaper failed, trying direct theme update..."
    # Fallback: call update-theme script directly
    if "$HOME/.config/hypr/scripts/update-theme.sh" "$current_wallpaper"; then
        echo ":: Theme update successful!"
        notify-send "Wallpaper Restored" "Startup wallpaper and theme restoration complete" 2>/dev/null
    else
        echo ":: Theme update failed!"
        notify-send "Wallpaper Error" "Theme update failed during startup" 2>/dev/null
        exit 1
    fi
fi

echo ":: Startup wallpaper and theme restoration complete!" 