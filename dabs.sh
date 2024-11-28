#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Directory to check and create
TARGET_DIR=~/dab

# Early check for existing directory
if [ -d "$TARGET_DIR" ]; then
    echo "Directory $TARGET_DIR already exists. Aborting."
    exit 1
fi

# Create directory
mkdir -p "$TARGET_DIR"

# Navigate to the directory
cd "$TARGET_DIR"

# Clone the repositories
git clone git@github.com:PhystecAB/dab_app.git
git clone git@github.com:PhystecAB/dab_netguard.git
git clone git@github.com:PhystecAB/dab_server.git
git clone git@github.com:PhystecAB/dab_summary.git
git clone git@github.com:PhystecAB/dab_utils.git
git clone git@github.com:PhystecAB/pall0.git
