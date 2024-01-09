[[ $(uname) == "Darwin" ]] && which zsh || brew install zsh
[[ $(uname) == "Linux" ]] && which zsh || apt install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
