function hunter
    env hunter
    if test -e ~/.hunter_cwd
      source ~/.hunter_cwd and \
      rm ~/.hunter_cwd and cd $HUNTER_CWD
    end
end
