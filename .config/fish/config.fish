# on login
if status --is-login
    echo "I logged in" > login.txt
    # Environment Variables
    #set -x NPM_PACKAGES "$HOME/.local/npm_packages"
    #set -x npm_config_prefix $NPM_PACKAGES/lib/node_modules
    #still trying to figure out how to handle env variales that are arrays
    #set -x NODE_PATH $NPM_PACKAGES/lib/node_modules{$NODE_PATH}
    #set -x MANPATH "$MANPATH:$NPM_PACKAGES/share/man"
    #set -x LD_LIBRARY_PATH /usr/lib64/openmpi
    set -gx EDITOR kak
    echo $EDITOR >> login.txt
    set -gx TERM kitty
    echo $TERM >> login.txt
    set -gx TERMCMD kitty
    echo $TERMCMD >> login.txt
    #Check if running sway and set environment variables
    set -qx SWAYSOCK; and set -gx QT_QPA_PLATFORM wayland; set -gx QT_QPA_PLATFORMTHEME qt5ct
    echo $QT_QPA_PLATFORM >> login.txt
end

# per instance
if status is-interactive
    # SSH with GPG
    set -e SSH_AGENT_PID
    if not set -q gnupg_SSH_AUTH_SOCK_by or test $gnupg_SSH_AUTH_SOCK_by -ne $fish_pid
        set -xg SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    end
    set -xg GPG_TTY (tty)
    gpg-connect-agent updatestartuptty /bye > /dev/null
end

# Aliases

alias dfconfig "git --git-dir=$HOME/.config/git/cfg/ --work-tree=$HOME"

alias ls "ls -1lih --color=auto"

alias grep "grep --color=auto"

# using starship as prompt
function fish_prompt
    starship init fish | source
end
