#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <github_user/repo>"
    exit 1
fi

PLUGIN_FULL="$1"
PLUGIN_USER=$(echo "$PLUGIN_FULL" | cut -d'/' -f 1)
PLUGIN_REPO=$(echo "$PLUGIN_FULL" | cut -d'/' -f 2)
PLUGIN_NAME=$(echo "$PLUGIN_REPO" | cut -d'.' -f 1)

INSTALL_DIR="$HOME/.config/nvim/pack/plugins/start/$PLUGIN_NAME"

if [ -d "$INSTALL_DIR" ]; then
    echo "Plugin already installed at $INSTALL_DIR"
    exit 0
fi

echo "Installing $PLUGIN_FULL to $INSTALL_DIR..."
git clone "https://github.com/$PLUGIN_FULL" "$INSTALL_DIR"
echo "Done."
