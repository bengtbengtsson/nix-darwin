#!/bin/bash

# Update Homebrew and upgrade existing packages
brew update && brew upgrade

# Install applications and tools via Homebrew
brew install \
    alacritty \
    cmatrix \
    docker \
    fossil \
    fzf \
    git \
    gnupg \
    htop \
    mkalias \
    neofetch \
    ripgrep \
    tmux \
    tree \
    watchman \
    wget

# Install additional tools from taps
brew tap mongodb/brew
brew install mongodb-community@5.0

# Install cask applications
brew install --cask \
    google-chrome \
    brave-browser \
    microsoft-office \
    microsoft-teams
    logisim-evolution \
    obsidian \
    postman \
    thonny \
    vlc \
    zoom \
    the-unarchiver

# Post-install message
echo "Installation complete. Review output for any issues."

# Optional: Cleanup
brew cleanup

