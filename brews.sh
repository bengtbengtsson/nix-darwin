#!/bin/bash

# Update Homebrew and upgrade existing packages
brew update && brew upgrade

# Install applications and tools via Homebrew
brew install \
    alacritty \
    bash \
    cmatrix \
    docker \
    fossil \
    fzf \
    git \
    gnupg \
    htop \
    mas \
    mongosh \
    neofetch \
    nushell \
    ripgrep \
    tmux \
    tree \
    watchman \
    wget \
    yazi

# Install additional tools from taps
brew tap mongodb/brew
brew install mongodb-community@5.0

# Install cask applications
brew install --cask \
    brave-browser \
    google-chrome \
    logisim-evolution \
    microsoft-office \
    microsoft-teams \
    obsidian \
    postman \
    raycast \
    the-unarchiver \
    thonny \
    vlc \
    zoom

# Post-install message
echo "Installation complete. Review output for any issues."

# Optional: Cleanup
brew cleanup

