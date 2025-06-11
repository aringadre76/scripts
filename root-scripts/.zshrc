#            _
#    _______| |__  _ __ ___
#   |_  / __| '_ \| '__/ __|
#  _ / /\__ \ | | | | | (__
# (_)___|___/_| |_|_|  \___|
#
# -----------------------------------------------------
# ML4W zshrc loader
# -----------------------------------------------------

# DON'T CHANGE THIS FILE

# You can define your custom configuration by adding
# files in ~/.config/zshrc
# or by creating a folder ~/.config/zshrc/custom
# with copies of files from ~/.config/zshrc
# -----------------------------------------------------

# -----------------------------------------------------
# Load modular configarion
# -----------------------------------------------------

for f in ~/.config/zshrc/*; do
    if [ ! -d $f ]; then
        c=`echo $f | sed -e "s=.config/zshrc=.config/zshrc/custom="`
        [[ -f $c ]] && source $c || source $f
    fi
done

# -----------------------------------------------------
# Load single customization file (if exists)
# -----------------------------------------------------

if [ -f ~/.zshrc_custom ]; then
    source ~/.zshrc_custom
fi

# Add ASCII animation function
function asciifetch() {
    ~/.config/simple-ascii-animation.sh "$@"
}

# Add rainbow neofetch function
function rneofetch() {
    neofetch | lolcat -a -d 1 -s 150
}

# Add animated neofetch function
function aneo() {
    bash ~/dotfiles/.config/animated-neofetch.sh "$@"
}

# Optional: Replace regular neofetch with animated version
# alias neofetch='bash ~/dotfiles/.config/animated-neofetch.sh'
