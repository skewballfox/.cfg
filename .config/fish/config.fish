#login
if status --is-login
    # Environment Variables
    set -x NPM_PACKAGES $HOME/.npm-packages
    #set -xU NODE_PATH $NPM_PACKAGES/lib/node_modules${NODE_PATH}
    set -x PATH $HOME/.local/bin $HOME/.cargo/bin $NPM_PACKAGES $PATH
    set -x EDITOR kak
end

# Aliases

alias dfconfig "git --git-dir=$HOME/.config/cfg/ --work-tree=$HOME"

alias ls "ls -1lih --color=auto"

alias grep="grep --color=auto"

# Prompt and aesthetics

function fish_prompt
    powerline-go -error $status -shell bare
end
