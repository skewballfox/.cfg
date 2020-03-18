#login
if status --is-login
    # Environment Variables
    set -x NPM_PACKAGES "$HOME/.local/npm_packages"
    set -x npm_config_prefix $NPM_PACKAGES/lib/node_modules
    #still trying to figure out how to handle env variales that are arrays
    set  NODE_PATH $NPM_PACKAGES/lib/node_modules{$NODE_PATH}
    set  MANPATH "$MANPATH:$NPM_PACKAGES/share/man"
    set -x EDITOR kak
    #set -x TERM
    #if command -v i3-config-wizard        
end

# Aliases

alias dfconfig "git --git-dir=$HOME/.config/git/cfg/ --work-tree=$HOME"

alias ls "ls -1lih --color=auto"

alias grep "grep --color=auto"

#alias ranger "ranger-cd" 

# Prompt and aesthetics

function fish_prompt
    powerline-rs  $status --cwd-max-dir-size 10 --shell bare
end
