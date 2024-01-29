function gfc
    gh repo fork --clone $argv
    set repo_name (string split '/' $argv)[-1]
    cd $repo_name
    git branch --set-upstream-to=origin
end
