#!/bin/bash
#  __     ______  __            _     _______          _                  
#  \ \   / / ___|/ _|   ___  __| | __|_   _| |__   ___| |_ __ ___   ___  
#   \ \ / /\___ \ |_   / _ \/ _` |/ _ \| | | '_ \ / _ \ | '_ ` _ \ / _ \ 
#    \ V /  ___) |  _|| (_) | (_| |  __/| | | | | |  __/ | | | | | |  __/
#     \_/  |____/|_|   \___/ \__,_|\___||_| |_| |_|\___|_|_| |_| |_|\___|
#                                                                        

# VSCode settings path
VSCODE_DIR="$HOME/.config/Code/User"
THEME_FILE="$VSCODE_DIR/settings.json"

# Make sure the directory exists
mkdir -p "$VSCODE_DIR"

# Path to pywal's VSCode color scheme
PYWAL_COLORS="$HOME/.cache/wal/colors-vscode.json"

# Check if the pywal colors file exists
if [ ! -f "$PYWAL_COLORS" ]; then
    echo "Pywal VSCode colors file not found: $PYWAL_COLORS"
    exit 1
fi

# Create a custom VSCode theme using pywal colors
create_theme() {
    # Load colors from pywal
    local COLORS=$(cat "$PYWAL_COLORS")
    
    # Create a timestamp for unique theme name
    local TIMESTAMP=$(date +%s)
    local THEME_NAME="Pywal Theme $TIMESTAMP"
    
    # Update VSCode settings to use our custom theme
    # If settings.json doesn't exist, create it
    if [ ! -f "$THEME_FILE" ]; then
        echo "{}" > "$THEME_FILE"
    fi
    
    # Update workbench.colorCustomizations in settings.json
    local TEMP_FILE=$(mktemp)
    
    # Use jq to update the settings file
    if command -v jq &> /dev/null; then
        # Extract the color customizations from pywal's file
        local COLOR_CUSTOMIZATIONS=$(jq '.workbench.colorCustomizations' "$PYWAL_COLORS")
        
        # Update settings.json with the new color customizations
        jq --argjson colors "$COLOR_CUSTOMIZATIONS" '.["workbench.colorCustomizations"] = $colors' "$THEME_FILE" > "$TEMP_FILE"
        mv "$TEMP_FILE" "$THEME_FILE"
        
        echo "VSCode theme updated successfully with pywal colors!"
    else
        echo "jq is not installed. Please install it to update VSCode theme."
        exit 1
    fi
}

# Main execution
create_theme 