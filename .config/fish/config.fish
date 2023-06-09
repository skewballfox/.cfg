
# per instance
if status is-interactive
    # SSH with GPG
    set -e SSH_AGENT_PID
    if not set -q gnupg_SSH_AUTH_SOCK_by or test $gnupg_SSH_AUTH_SOCK_by -ne $fish_pid
        set -xg SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    end
    set -xg GPG_TTY (tty)
    gpg-connect-agent updatestartuptty /bye > /dev/null
    ## Most of the stuff here, at some point, will be system dependent
    if test -e ~/.asdf/asdf.fish
        source ~/.asdf/asdf.fish
    end
    command -sq zoxide; and zoxide init --cmd cd fish | source
    command -sq atuin; and atuin init fish | source
    #if type -q atuin
    #    set -gx ATUIN_NOBIND "true"
    #    atuin init fish | source
    #    bind \e\[A  _atuin_search_widget
    #    bind \e[1;2A  __atuin_history
    #end
    command -sq portmod; and register-python-argcomplete --shell fish portmod | source
end

# Aliases

alias dfconfig "git --git-dir=$HOME/.config/git/cfg/ --work-tree=$HOME"

alias ls "ls -1lih --color=auto"

alias grep "grep --color=auto"

# using starship as prompt
function fish_prompt
    starship init fish | source
end
