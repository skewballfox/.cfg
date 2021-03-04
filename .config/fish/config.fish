#login
if status --is-login
    # Environment Variables
    set -x NPM_PACKAGES "$HOME/.local/npm_packages"
    set -x npm_config_prefix $NPM_PACKAGES/lib/node_modules
    #still trying to figure out how to handle env variales that are arrays
    set -x NODE_PATH $NPM_PACKAGES/lib/node_modules{$NODE_PATH}
    set -x MANPATH "$MANPATH:$NPM_PACKAGES/share/man"
    set -x LD_LIBRARY_PATH /usr/lib64/openmpi
    set -x EDITOR kak
    set -x TERM kitty
    set -x TERMCMD kitty
    #Check if running sway and set environment variables
    set -qx SWAYSOCK; set -x QT_QPA_PLATFORM qt5ct
#per instance
end
    
# SSH with GPG
set -e SSH_AGENT_PID
if not set -q gnupg_SSH_AUTH_SOCK_by or test $gnupg_SSH_AUTH_SOCK_by -ne $fish_pid
    set -xg SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
end
set -xg GPG_TTY (tty)
gpg-connect-agent updatestartuptty /bye > /dev/null


# Aliases

alias dfconfig "git --git-dir=$HOME/.config/git/cfg/ --work-tree=$HOME"

alias ls "ls -1lih --color=auto"

alias grep "grep --color=auto"

#functions silver
function fish_prompt
    starship init fish | source
end
