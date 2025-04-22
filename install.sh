#!/bin/zsh

set -e  # Exit script on any command failure

# Detect OS
OS="$(uname -s)"
if [[ "$OS" == "Darwin" ]]; then
    PACKAGE_MANAGER="brew"
elif [[ -f "/etc/arch-release" ]]; then
    PACKAGE_MANAGER="pacman"
else
    echo "Unsupported OS. This script supports macOS and Arch Linux only."
    exit 1
fi

# Define package lists using Zsh-style associative arrays
typeset -A PACKAGES
PACKAGES["common"]="btop fzf libpq php mysql ncdu neovim zoxide zsh"
PACKAGES["Darwin"]="supabase/tap/supabase"
PACKAGES["Arch"]="base-devel sudo wget htop"

typeset -A CASKS
CASKS["Darwin"]="discord google-chrome iterm2 karabiner-elements monitorcontrol neovide nikitabobko/tap/aerospace pgadmin4 slack"

# Install Homebrew if missing (macOS)
install_homebrew() {
    if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew is already installed."
    fi
}

# Install Yay (Arch AUR helper) if missing
install_yay() {
    if ! command -v yay &>/dev/null; then
        echo "Installing yay (AUR helper)..."
        sudo pacman -Syu --noconfirm --needed base-devel git
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay
        makepkg -si --noconfirm
        cd - && rm -rf /tmp/yay
    fi
}

# Install CLI dependencies
install_dependencies() {
    echo "Installing dependencies..."

    package_list="${PACKAGES["common"]} ${PACKAGES["$OS"]}"

    if [[ "$PACKAGE_MANAGER" == "brew" ]]; then
        brew install $package_list
    elif [[ "$PACKAGE_MANAGER" == "pacman" ]]; then
        sudo pacman -Syu --noconfirm --needed $package_list
    fi
}

# Install GUI applications (macOS casks)
install_casks() {
    if [[ "$PACKAGE_MANAGER" == "brew" ]] && [[ -n "${CASKS["Darwin"]}" ]]; then
        echo "Installing GUI applications (casks)..."
        brew install --cask ${CASKS["Darwin"]}
    fi
}

# Clone and symlink dotfiles
setup_dotfiles() {
    DOTFILES_REPO="https://github.com/StevenRotelli/dotfiles.git"
    DOTFILES_DIR="$HOME/.dotfiles"

    if [[ -d "$DOTFILES_DIR" ]]; then
        echo "Updating existing dotfiles..."
        git -C "$DOTFILES_DIR" pull
    else
        echo "Cloning dotfiles..."
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    fi

    echo "Creating symlinks..."
    ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    ln -sf "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
    ln -sf "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
}

# Spinner function for smooth CLI loading effect
spinner() {
    pid=$1
    message=$2
    delay=0.1
    spinstr='|/-\'

    tput civis  # Hide cursor
    while kill -0 $pid 2>/dev/null; do
        temp=${spinstr#?}
        printf "\e[1;34m[%c]\e[0m %s" "$spinstr" "$message"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\r"
    done
    tput cnorm  # Restore cursor

    wait $pid
    exit_code=$?

    if [[ $exit_code -eq 0 ]]; then
        printf "\e[1;32m[✔]\e[0m %s\n" "$message"
    else
        printf "\e[1;31m[✖]\e[0m %s (Failed)\n" "$message"
    fi
}

# Run installation steps with spinner
if [[ "$PACKAGE_MANAGER" == "brew" ]]; then
    install_homebrew &
    spinner $! "Installing Homebrew"
fi

install_dependencies &
spinner $! "Installing dependencies"

if [[ "$PACKAGE_MANAGER" == "brew" ]]; then
    install_casks &
    spinner $! "Installing macOS casks"
fi

setup_dotfiles &
spinner $! "Setting up dotfiles"

echo "Installation complete. Restart your terminal."

