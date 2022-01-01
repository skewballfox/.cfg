################### Universal Vars ########################
#include local desktop files in data dir
export XDG_DATA_DIRS="$HOME/.local/share/applications:${XDG_DATA_DIRS}"
if [ -x "$(which npm)" ]; then
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
if [ -x "$(which go)" ]; then
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

# set path to libraries
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib:/usr/lib64:/usr/local/lib:/usr/local/lib64"

if [ -x "$(which java)" ]; then
    # Set JDK installation directory according to selected Java compiler
    export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::")
fi

######################## HOST SPECIFIC VARS #####################
#export ARGOS_HOME=/home/daedalus/Workspace/Group_Projects/Argos

if [ -z $DISPLAY ] && [[ "$(tty)" =~ /dev/tty[0-9] ]]; then

    driver=$(lspci -nnk | grep 0300 -A3 | grep -oP "(?<=driver in use: ).*")

    export QT_QPA_PLATFORM=wayland
    export QT_QPA_PLATFORMTHEME=qt5ct

    #export QT_AUTO_SCREEN_SCALE_FACTOR=1
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

    #NOTE: Simple DirectMedia Layer
    export SDL_VIDEODRIVER=wayland

    #so thunderbird-wayland will actually use wayland
    export MOZ_ENABLE_WAYLAND=1
    #think it's used for obs studio
    export MOZ_WEBRENDER=1

    export _JAVA_AWT_WM_NONREPARENTING=1
    #export WLR_DRM_NO_MODIFIERS=1

    #necessary for tumbler apparently
    export XDG_CACHE_HOME=$HOME/.cache
    
    #stuff to try to get gnome-pinentry and seahorse
    #to properly work
    export XDG_CURRENT_DESKTOP=sway
    export XDG_SESSION_DESKTOP=sway
    export XDG_SESSION_TYPE=wayland
    export CURRENT_DESKTOP=sway

    if command -v systemctl >/dev/null 2>&1; then
        systemctl --user import-environment XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE
    fi

    #export $(gnome-keyring-daemon --start --components=secrets)
    #apparently pkcs11 support is deprecated
    # https://fedoraproject.org/wiki/Changes/ModularGnomeKeyring

    #Stuff related to running sway with Nvidia
    if [[ $driver == "nvidia" ]]; then
    	export WLR_NO_HARDWARE_CURSORS=1
        export GBM_BACKEND=nvidia-drm
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
    	exec sway --unsupported-gpu
    else
	#Used to avoid showing a corrupted image on startup with the nouveau drivers
	#for some reason causes sway to dump core with nvidia drivers
	export WLR_DRM_NO_MODIFIERS=1
        exec sway
    fi
fi
