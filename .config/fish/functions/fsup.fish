function fsup
    #Fedora System Update
    echo -e "\nstarting system upgrade\n"
    sudo dnf upgrade
    echo -e "\nupgrading pip user installs\n"
    pip3 install --user (pip3 list --user --outdated | tail -n +3 | awk '{print $1}') --upgrade
    echo -e "\nupgrading npm packages"
    npm update -g
    echo -e "\nupdating rust toolchain\n"
    rustup update
    echo -e "\nupdating cargo packages\n"
    cargo install-update -a
end
