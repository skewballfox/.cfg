# .bashrc

# If not running interactively, don't do anything                                                                                                                          
[ -z "$PS1" ] && return                                                                                                                                                            
# don't put duplicate lines in the history or force ignoredups and ignorespace                                                                                                                                  
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it     
shopt -s histappend


# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
   . /etc/bash_completion
fi
  

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY="$(tty)"
gpg-connect-agent updatestartuptty /bye > /dev/null

# enable asdf
# . $HOME/.asdf/asdf.sh
# enable asdf completions
# . $HOME/.asdf/completions/asdf.bash

#################### ALIASES #########################
alias dfconfig="git --git-dir=$HOME/.config/git/cfg/ --work-tree=$HOME"

alias ls="ls -1lih --color=auto"

alias grep="grep --color=auto"


# Set Starship prompt
eval "$(starship init bash)"

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=


. "/home/skewballfox/.wasmedge/env"
