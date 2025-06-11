# Scripts Backup Repository

This repository contains a backup of all custom scripts from my Hyprland dotfiles configuration.

## Directory Structure

### `hypr/scripts/`
**Main Hyprland automation scripts** - The core scripts that power my Hyprland setup:

#### **Theme & Wallpaper Management**
- `startup-wallpaper.sh` - Restores wallpaper and theme on startup with multiple fallback mechanisms
- `update-theme.sh` - Main theme update script that applies wallpaper-based colors to all components
- `wallpaper.sh` - Original ML4W wallpaper script with effects and caching
- `wallpaper-automation.sh` - Automated wallpaper changing
- `wallpaper-cache.sh` - Wallpaper caching utilities
- `wallpaper-effects.sh` - Wallpaper blur and effects management
- `wallpaper-restore.sh` - Wallpaper restoration functionality
- `set-persistent-wallpaper.sh` - Saves wallpaper for persistence across reboots
- `reload-theme.sh` - Quick theme reloading

#### **System Management**
- `power.sh` - Power management menu (shutdown, reboot, logout, etc.)
- `gamemode.sh` - Gaming mode toggle with performance optimizations
- `hypridle.sh` - Idle management and screen timeout controls
- `restart-hypridle.sh` - Restart idle daemon
- `systeminfo.sh` - System information display
- `cleanup.sh` - System cleanup utilities

#### **Window Management**
- `moveTo.sh` - Move windows to specific workspaces
- `toggleallfloat.sh` - Toggle all windows to floating mode
- `toggle-animations.sh` - Toggle window animations
- `show-desktop.sh` - Show/hide desktop (minimize all windows)
- `toggle-desktop.sh` - Desktop toggle functionality

#### **Interactive & Display**
- `screenshot.sh` - Advanced screenshot functionality with multiple modes
- `keybindings.sh` - Display keybindings help
- `hyprshade.sh` - Blue light filter and screen shader management

#### **System Integration**
- `gtk.sh` - GTK theme synchronization
- `xdg.sh` - XDG portal management
- `init-wallpaper-engine.sh` - Wallpaper engine initialization
- `loadconfig.sh` - Configuration loading
- `disabledm.sh` - Display manager control

#### **Application Launchers**
- `launch-chrome.sh` - Chrome browser launcher

#### **Development & Testing**
- `test-colors.sh` - Color scheme testing
- `test.sh` - General testing script
- `update-vscode-theme.sh` - VSCode theme synchronization

### `waybar/`
**Waybar status bar scripts**:
- `launch.sh` - Waybar launcher with theme detection
- `toggle.sh` - Toggle waybar visibility
- `themeswitcher.sh` - Switch between waybar themes

### `ml4w/`
**ML4W framework scripts** - Scripts from the ML4W desktop framework:
- Various system integration and utility scripts
- Desktop environment management tools

### `config-scripts/`
**Configuration and utility scripts**:
- `nwg-dock-launch.sh` - Launch script for nwg-dock taskbar
- Various configuration management scripts

### `templates/`
**Pywal color templates** - Used to generate theme files:
- `colors-gtk3.css` - GTK3 application theming (Thunar file manager, etc.)
- `colors-nwg-dock.css` - Taskbar color theming
- `colors-waybar.css` - Waybar color theming
- Other pywal templates for various applications

### `root-scripts/`
**Root-level configuration files with embedded scripts**:
- `.bashrc` - Bash shell configuration with custom functions
- `.zshrc` - Zsh shell configuration with custom functions  
- `fetch.sh` - System info fetch script

## Key Features

### **Unified Theme System**
The `update-theme.sh` script creates a cohesive theming experience by applying wallpaper-based colors to:
- Hyprland window manager (borders, decorations)
- Kitty terminal emulator  
- Thunar file manager
- nwg-dock taskbar
- Waybar status bar
- Oh My Posh prompt
- Cursor IDE
- Spotify (via Spicetify)

### **Smart Wallpaper Management**
- Automatic wallpaper restoration on startup
- Multiple fallback mechanisms for wallpaper detection
- Persistent wallpaper storage across reboots
- Wallpaper effects and caching system

### **System Integration**
- GTK theme synchronization
- Gaming mode optimizations  
- Power management integration
- Screenshot functionality
- Window management utilities

## Usage

### Main Theme Update
```bash
# Update theme based on current wallpaper
~/.config/hypr/scripts/update-theme.sh "/path/to/wallpaper.jpg"
```

### Wallpaper Management
```bash
# Set persistent wallpaper
~/.config/hypr/scripts/set-persistent-wallpaper.sh "/path/to/wallpaper.jpg"

# Restore wallpaper on startup
~/.config/hypr/scripts/startup-wallpaper.sh
```

### System Controls
```bash
# Power menu
~/.config/hypr/scripts/power.sh

# Toggle gaming mode
~/.config/hypr/scripts/gamemode.sh

# Take screenshot
~/.config/hypr/scripts/screenshot.sh
```

## Dependencies

- **Hyprland** - Window manager
- **pywal** - Color scheme generation  
- **waybar** - Status bar
- **kitty** - Terminal emulator
- **thunar** - File manager
- **nwg-dock-hyprland** - Taskbar
- **matugen** - Material Design color generation
- **waypaper** - Wallpaper management GUI

## Installation

1. Clone this repository as a backup
2. Copy scripts to appropriate locations in your dotfiles
3. Make scripts executable: `chmod +x script_name.sh`
4. Ensure dependencies are installed

## Notes

- All scripts are designed for Arch Linux with Hyprland
- Scripts include error handling and fallback mechanisms
- Color templates use pywal syntax for dynamic theming
- Many scripts can run independently or as part of the theme system

---

**Last Updated**: June 2024  
**Environment**: Arch Linux + Hyprland + ML4W Framework