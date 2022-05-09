
# on login
#if status --is-login
    #set -x LD_LIBRARY_PATH /usr/lib64/openmpi
#    set -gx EDITOR kak
#    set -gx TERM kitty
#    set -gx TERMCMD kitty
    #Check if running sway and set environment variables
    #set -qx SWAYSOCK; and set -gx QT_QPA_PLATFORM wayland; set -gx QT_QPA_PLATFORMTHEME qt5ct
#end

# per instance
if status is-interactive
    # SSH with GPG
    set -e SSH_AGENT_PID
    if not set -q gnupg_SSH_AUTH_SOCK_by or test $gnupg_SSH_AUTH_SOCK_by -ne $fish_pid
        set -xg SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    end
    set -xg GPG_TTY (tty)
    gpg-connect-agent updatestartuptty /bye > /dev/null
    source ~/.asdf/asdf.fish
    zoxide init --cmd cd fish | source
    register-python-argcomplete --shell fish portmod | source
end

# Aliases

alias dfconfig "git --git-dir=$HOME/.config/git/cfg/ --work-tree=$HOME"

alias ls "ls -1lih --color=auto"

alias grep "grep --color=auto"

# using starship as prompt
function fish_prompt
    starship init fish | source
end
