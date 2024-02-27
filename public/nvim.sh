#!/bin/bash
set -ex

# Function to install packages using detected package manager
install_packages() {
    if command -v apt >/dev/null; then
        sudo apt install git cmake gettext -y
    elif command -v yum >/dev/null; then
        sudo yum install git cmake gettext -y
    elif command -v dnf >/dev/null; then
        sudo dnf install git cmake gettext -y
    elif command -v pacman >/dev/null; then
        sudo pacman -S --noconfirm git cmake gettext
    elif command -v zypper >/dev/null; then
        sudo zypper install git cmake gettext
    elif command -v brew >/dev/null; then
        brew install git cmake
    else
        echo "No recognized package manager found. Install git and cmake manually."
        exit 1
    fi
}

# Clone and install neovim
test -d neovim && rm -rf neovim
git clone https://github.com/neovim/neovim --depth=1
cd neovim
make CMAKE_BUILD_TYPE=Release
sudo make install

# Clone and install AstroNvim
git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
curl -L https://cm2.fi/init.lua --ouput ~/.config/nvim/init.lua

echo "[+] Done run nvim to get started"
exit 0 
