function fsup
    #Fedora System Update
    sudo dnf upgrade
    pip install --user '(pip list --user --outdated | tail -n +3 | awk "{print $1}")' --upgrade
    rustup Update
    cargo install-update -a
end
