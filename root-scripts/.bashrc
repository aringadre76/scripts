#    _               _              
#   | |__   __ _ ___| |__  _ __ ___ 
#   | '_ \ / _` / __| '_ \| '__/ __|
#  _| |_) | (_| \__ \ | | | | | (__ 
# (_)_.__/ \__,_|___/_| |_|_|  \___|
# 
# -----------------------------------------------------
# ML4W bashrc loader
# -----------------------------------------------------

# DON'T CHANGE THIS FILE

# You can define your custom configuration by adding
# files in ~/.config/bashrc 
# or by creating a folder ~/.config/bashrc/custom
# with copies of files from ~/.config/bashrc 
# You can also create a .bashrc_custom file in your home directory
# -----------------------------------------------------

# -----------------------------------------------------
# Load modular configarion
# -----------------------------------------------------

for f in ~/.config/bashrc/*; do 
    if [ ! -d $f ]; then
        c=`echo $f | sed -e "s=.config/bashrc=.config/bashrc/custom="`
        [[ -f $c ]] && source $c || source $f
    fi
done

# -----------------------------------------------------
# Load single customization file (if exists)
# -----------------------------------------------------

if [ -f ~/.bashrc_custom ]; then
    source ~/.bashrc_custom
fi

# Add ASCII animation function
function asciifetch() {
    ~/.config/simple-ascii-animation.sh "$@"
}

# Add rainbow neofetch function
function rneofetch() {
    neofetch | lolcat -a -d 1 -s 150
}

# Replace default neofetch with custom ASCII art
alias neofetch='neofetch --ascii ~/ascii_art/small.txt --ascii_colors 1 2 3 4 5 6'

# Add local bin directory to PATH for pywal16
export PATH="$PATH:$HOME/.local/bin" 
export PATH=$PATH:/home/arin/.spicetify
