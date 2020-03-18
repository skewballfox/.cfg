function sup
    if command -v termux-setup-storage
        pkg upgrade
    else if command -v dnf
        sudo dnf upgrade
        echo -e "\nupdating rust toolchain\n"
        rustup update
    end
    echo -e "\nupdating cargo packages\n"
    cargo install-update -a
    echo -e "\nupgrading pip user installs\n"
    pip install --user (pip list --user --outdated | tail -n +3 | awk '{print $1}') --upgrade
    echo -e "\nupgrading npm global installs\n"
    npm update -g
        
        
