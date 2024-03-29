################### Universal Vars ########################
#include local desktop files in data dir
export XDG_DATA_HOME="$HOME/.local/share"
if [ -x "$(command -v npm)" ]; then
    #set location for npm packages
    export NPM_PACKAGES="$HOME/.local/npm_packages"
    #update MANPATH
    export MANPATH="${MANPATH}:$NPM_PACKAGES/share/man"
    #set npm config prefix
    export npm_config_prefix=$HOME/.local/npm_packages/lib/node_modules
    #add NPM to path
    PATH="$HOME/.local/npm_packages/lib/node_modules/bin:${PATH}"
fi

if [[ -d "$HOME/Workspace/build/flutter/bin" ]]; then
    PATH="$HOME/Workspace/build/flutter/bin:${PATH}"
fi

#add Cargo to path
if [[ -d "$HOME/.cargo" ]]; then
    PATH="$HOME/.cargo/bin:${PATH}"
fi

#add go bin to path
if [ -x "$(command -v go)" ]; then
    export GOPATH=$HOME/.local/go
    PATH="$HOME/.local/go/bin:${PATH}"
fi

if [[ -d "$HOME/.local/Android" ]]; then
    export ANDROID_HOME="$HOME/.local/Android"
    export ANDROID_SDK_ROOT="$ANDROID_HOME"
    PATH="$ANDROID_HOME/bin:${PATH}"
fi

if [ -x "$(command -v cs)" ]; then
    export PATH="$PATH:$HOME/.local/share/coursier/bin"
fi

#add .local bin
PATH="$HOME/.local/bin:${PATH}"

if [ -d "$HOME/.pub-cache" ]; then
    PATH="$PATH":"$HOME/.pub-cache/bin"
fi

#stuff for fluvio
if [ -d "$HOME/.fluvio" ]; then
     PATH="$PATH":"$HOME/.fluvio/bin"
fi

#handling android tools via android studio
if [ -d "$HOME/Android/Sdk/platform-tools" ]; then
    PATH="$PATH":"$HOME/Android/Sdk/platform-tools/"
fi

if [[ -x "$(command -v kani)" ]]; then
    export KANI_HOME="$HOME/.local/kani"
fi

#Export the modified path
export PATH

#set default terminal
export TERM=kitty
export TERMCMD=kitty

#set default editor
export EDITOR=kak

#set the directory for taskwarrior-server
export TASKDDATA=/var/lib/taskd

# set path to libraries
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/lib:/lib64:/usr/lib:/usr/lib64:/usr/local/lib:/usr/local/lib64:$HOME/.local/lib"

if [ -x "$(command -v java)" ]; then
    # Set JDK installation directory according to selected Java compiler
    export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::")
fi

#Playing around with wasmedge runtime
#https://wasmedge.org/book/en/write_wasm/rust/wasinn.html#get-wasmedge-with-wasi-nn-plug-in-tensorflow-lite-backend
if [ -d "$HOME/.wasmedge" ]; then
    . "$HOME/.wasmedge/env"
    # https://docs.rs/crate/wasmedge-sys/latest#Build
    export WASMEDGE_INCLUDE_DIR=$HOME/wasmedge-install/include 
    export WASMEDGE_LIB_DIR=$HOME/wasmedge-install/lib
    export WASMEDGE_PLUGIN_PATH=$HOME/.wasmedge/lib/wasmedge
    
fi

# check if running docker rootless, if so set docker host
if [ -f "$HOME/.config/systemd/user/docker.service" ]; then
    USER_ID=$(id -u)
    export DOCKER_HOST=unix:///run/user/$USER_ID/docker.sock
fi

######################## HOST SPECIFIC VARS #####################
#export ARGOS_HOME=/home/daedalus/Workspace/Group_Projects/Argos

# thanks to https://stackoverflow.com/a/28926650/11019565
ingroup(){ [[ " `id -Gn $2` " == *" $1 "* ]]; }

if ! ingroup wheel; then
    CMAKE_PREFIX_PATH=$HOME/.local
    CMAKE_INSTALL_PREFIX=$HOME/.local
fi

sway_cmd(){
    if ! ingroup wheel; then
        exec dbus-run-session sway
    fi
}

# Auto logout of user account if inactive for 30 minutes
if ingroup wheel; then
    TMOUT=1800
fi

#Set variables for graphical session if one isn't running
if [ -z $DISPLAY ] && [[ "$(tty)" =~ /dev/tty[0-9] ]]; then

    # pactl load-module module-echo-cancel

    driver=$(lspci -nnk | grep 0300 -A3 | grep -oP "(?<=driver in use: ).*")

    export QT_QPA_PLATFORM=wayland
    export QT_QPA_PLATFORMTHEME=qt5ct
    
    #export QT_AUTO_SCREEN_SCALE_FACTOR=1
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

    export GDK_BACKEND=wayland

    #NOTE: Simple DirectMedia Layer
    export SDL_VIDEODRIVER=wayland

    #so thunderbird-wayland will actually use wayland
    export MOZ_ENABLE_WAYLAND=1
    #think it's used for obs studio
    export MOZ_WEBRENDER=1

    # for IntelliJ, Android Studio, etc
    # https://stackoverflow.com/questions/33424736/intellij-idea-14-on-arch-linux-opening-to-grey-screen/34419927#34419927
    export _JAVA_AWT_WM_NONREPARENTING=1

    #necessary for tumbler apparently
    export XDG_CACHE_HOME=$HOME/.cache
    
    #stuff to try to get gnome-pinentry and seahorse
    #to properly work
    export XDG_CURRENT_DESKTOP=sway
    export XDG_SESSION_DESKTOP=sway
    export XDG_SESSION_TYPE=wayland
    export CURRENT_DESKTOP=sway

    # Vukan rendering for wlroots
    # NOTE: requires vulkan-validation-layers
    # https://wiki.archlinux.org/title/sway#Use_another_wlroots_renderersw
    export WLR_RENDERER=vulkan

    if command -v systemctl >/dev/null 2>&1; then
        systemctl --user import-environment XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE
    fi

    # for Tauri/WINIT apps to use wayland

    #I think this is necessary if using dbus-run-session
    #dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

    #export $(gnome-keyring-daemon --start --components=secrets)
    #apparently pkcs11 support is deprecated
    # https://fedoraproject.org/wiki/Changes/ModularGnomeKeyring

    #Stuff related to running sway with Nvidia
    if [[ $driver == "nvidia" ]]; then
        export WLR_NO_HARDWARE_CURSORS=1
        export GBM_BACKEND=nvidia-drm
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
    	ingroup wheel || exec sway-git --unsupported-gpu -D noscanout
    else
	    # Used to avoid showing a corrupted image on startup with the nouveau drivers
	    # for some reason causes sway to dump core with nvidia drivers
	    export WLR_DRM_NO_MODIFIERS=1
        ingroup wheel || exec dbus-run-session sway-git
    fi
fi

. "/home/skewballfox/.wasmedge/env"
