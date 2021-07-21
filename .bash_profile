################### Universal Vars ########################
#include local desktop files in data dir
export XDG_DATA_DIRS="$HOME/.local/share/applications:${XDG_DATA_DIRS}"
if [ -x "$(which npm)" ]
then  
    #set location for npm packages
    export NPM_PACKAGES="$HOME/.local/npm_packages"
    #update MANPATH
    export MANPATH="${MANPATH}:$NPM_PACKAGES/share/man"
    #set npm config prefix
    export npm_config_prefix=$HOME/.local/npm_packages/lib/node_modules
    #add NPM to path
    PATH="$HOME/.local/npm_packages/lib/node_modules/bin:${PATH}"
fi

#add Cargo to path
if [[ -d "$HOME/.cargo" ]]; then
    PATH="$HOME/.cargo/bin:${PATH}"
fi

#add go bin to path
if [ -x "$(which go)" ]
then
    PATH="$HOME/.local/go/bin:${PATH}"
fi

#add .local bin
PATH="$HOME/.local/bin:${PATH}"


#Export the modified path
export PATH

#set default terminal
export TERM=kitty
export TERMCMD=kitty

#set default editor
export EDITOR=kak

# load openmpi lib
if [ -d /usr/lib64/openmpi ]
then 
    export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib64/openmpi"
fi
######################## HOST SPECIFIC VARS #####################
#export ARGOS_HOME=/home/daedalus/Workspace/Group_Projects/Argos


if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
    export QT_QPA_PLATFORM=wayland
    export QT_QPA_PLATFORMTHEME=qt5ct
    export MOZ_ENABLE_WAYLAND=1
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib"
    export _JAVA_AWT_WM_NONREPARENTING=1
    export WLR_DRM_NO_MODIFIERS=1
    export XDG_CURRENT_DESKTOP=sway
    export CURRENT_DESKTOP=sway
    exec sway
fi


