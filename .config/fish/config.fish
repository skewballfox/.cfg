#login
#if status --is-login
    # Environment Variables
#    set -x NPM_PACKAGES "$HOME/.local/npm_packages"
    #set -xU NODE_PATH $NPM_PACKAGES/lib/node_modules${NODE_PATH}
#    set -x PATH $HOME/.local/bin $HOME/.cargo/bin $NPM_PACKAGES/bin $PATH
#    set -x MANPATH $NPM_PACKAGES/share/man $MANPATH
#    set -x EDITOR kak
#end

# Aliases

alias dfconfig "git --git-dir=$HOME/.config/git/cfg/ --work-tree=$HOME"

alias ls "ls -1lih --color=auto"

alias grep="grep --color=auto"

# Prompt and aesthetics

function fish_prompt
    powerline-rs  $status --shell bare
end
