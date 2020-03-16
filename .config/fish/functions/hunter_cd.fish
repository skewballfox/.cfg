function hunter
    env hunter
    test -e ~/.hunter_cwd and \
    source ~/.hunter_cwd and \
    rm ~/.hunter_cwd && cd $HUNTER_CWD
end
