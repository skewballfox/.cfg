#to disable warnings with powerlevel9k theme
export TERM="xterm-256color"

#to enable patched glyphs
source /usr/share/fonts/awesome-terminal-fonts/*.sh
POWERLEVEL9K_MODE='awesome-fontconfig'

# If you come from bash you might have to change your $PATH.
 export PATH=$HOME/bin:/usr/local/bin:$PATH
 export PATH=$HOME/.dotnet/tools:$PATH

# Path to your oh-my-zsh installation.
  export ZSH="/home/daedalus/.oh-my-zsh"

#for running npm without global permissions
export NPM_PACKAGES="/home/daedalus/.npm-packages"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules${NODE_PATH:+:$NODE_PATH}"
export PATH="$NPM_PACKAGES/bin:$PATH"

# Unset manpath so we can inherit from /etc/manpath via the `manpath`
# command
unset MANPATH  # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

#checking out powerlevel9k
source /usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  archlinux
  python
  rust
  rustup
  adb
  taskwarrior
  buku
)

#rice rice baby
source $ZSH/oh-my-zsh.sh
#to search for package if command isn't found
source /usr/share/doc/pkgfile/command-not-found.zsh
#to use zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='kak'
else
  export EDITOR='kak'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"
# completion for powerpill

compdef _pacman powerpill=pacman

##################### 9k tweaks ################################################
################################################################################

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context history time dir vcs newline os_icon)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status)
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

################################# Aliases #####################################
###############################################################################

#the below is to allow aliases to be passed to sudo
alias sudo='sudo '
#the below is to backup my dotfiles to github
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
#the below alias is to modify default ls behavior
alias ls='ls -1lih --color=auto'
#color output with grep
alias grep='grep --color=auto'
#reload zsh
alias zr='source $HOME/.zshrc'
#reading list
alias rtask="task rc.data.location=~/gdrive/.reading_list"

############################### Environment Variables ########################
##############################################################################

#using rust
export PATH=$PATH:~/.cargo/bin

#the location of the self_log directory
export SLog_directory="$HOME/Gdrive/self_log"

#the location of system tools
export Sys_Tools_Directory="$HOME/Workspace/System_Tools"

############################# reshash-hook ###################################
##############################################################################

zshcache_time="$(date +%s%N)"

autoload -Uz add-zsh-hook

rehash_precmd() {
      if [[ -a /var/cache/zsh/pacman ]]; then
         local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
         if (( zshcache_time < paccache_time )); then
            rehash
            zshcache_time="$paccache_time"
         fi
       fi
}

add-zsh-hook -Uz precmd rehash_precmd

# If the precmd hook is triggered before /var/cache/zsh/pacman is updated,
# completion may not work until a new prompt is initiated. Running an empty
# command, e.g. pressing enter, should be sufficient.

########################### Colored output for man ########################
###########################################################################

man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}
                            

# For a full list of active aliases, run `alias`.
