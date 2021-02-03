function sup
    if command -v termux-setup-storage
        pkg upgrade
    else if command -v dnf
        sudo dnf upgrade -y
        echo -e "\nupdating rust toolchain\n"
        rustup update
    end

    echo -e "\nupdating cargo packages\n"
    cargo install-update -a

    echo -e "\nupgrading pip user installs\n"
    pip install --user (pip list --user --outdated | tail -n +3 | awk '{ print $1 }' ) --upgrade
    # until I fix the above
    pip install --user --upgrade Python-language-server

    echo -e "\nupgrading npm global installs\n"
    npm update -g

    if test -e ~/Media/Source/kwin-tiling
        "\nupdating tiling script for kwin\n"
        git -C ~/Media/Source/kwin-tiling/ pull
        plasmapkg2 --type kwinscript -u ~/Media/Source/kwin-tiling
    end
    if command  -v kak
        kak -e plug-update
    end
end        
        
