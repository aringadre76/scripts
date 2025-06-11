#!/bin/bash

# Script to test terminal colors
echo "🎨 Current Color Scheme Test"
echo "============================"
echo

echo "Standard colors:"
for i in {0..7}; do
    echo -en "\e[${i}m●\e[0m "
done
echo

echo "Bright colors:"
for i in {8..15}; do
    echo -en "\e[1;$((i-8))m●\e[0m "
done
echo
echo

echo "Color palette:"
echo -e "\e[30m■ Black (0)\e[0m"
echo -e "\e[31m■ Red (1)\e[0m"  
echo -e "\e[32m■ Green (2)\e[0m"
echo -e "\e[33m■ Yellow (3)\e[0m"
echo -e "\e[34m■ Blue (4)\e[0m"
echo -e "\e[35m■ Magenta (5)\e[0m"
echo -e "\e[36m■ Cyan (6)\e[0m"
echo -e "\e[37m■ White (7)\e[0m"
echo

if [ -f ~/.cache/wal/colors ]; then
    echo "Current wallpaper colors:"
    cat ~/.cache/wal/colors | nl -w2 -s': '
fi 