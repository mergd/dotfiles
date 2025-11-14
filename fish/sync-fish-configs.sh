#!/usr/bin/env bash
# Sync Fish shell configuration from dotfiles to ~/.config/fish/

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FISH_CONFIG_DIR="$HOME/.config/fish"

echo "🐟 Syncing Fish configuration..."

# Create Fish config directory if it doesn't exist
mkdir -p "$FISH_CONFIG_DIR"
mkdir -p "$FISH_CONFIG_DIR/completions"
mkdir -p "$FISH_CONFIG_DIR/conf.d"
mkdir -p "$FISH_CONFIG_DIR/functions"
mkdir -p "$FISH_CONFIG_DIR/themes"

# Function to create symlink, backing up existing file if needed
link_file() {
    local source="$1"
    local dest="$2"
    local name="$3"
    
    if [ -L "$dest" ]; then
        echo "  ✓ $name already linked"
        return
    fi
    
    if [ -e "$dest" ]; then
        echo "  ⚠ Backing up existing $name..."
        mv "$dest" "$dest.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    ln -sf "$source" "$dest"
    echo "  ✓ Linked $name"
}

# Link main config file
link_file "$DOTFILES_DIR/fish/config.fish" "$FISH_CONFIG_DIR/config.fish" "config.fish"

# Link conf.d files
echo "Linking conf.d files..."
for file in "$DOTFILES_DIR/fish/conf.d"/*.fish; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        link_file "$file" "$FISH_CONFIG_DIR/conf.d/$filename" "conf.d/$filename"
    fi
done

# Link completions
echo "Linking completions..."
for file in "$DOTFILES_DIR/fish/completions"/*.fish; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        link_file "$file" "$FISH_CONFIG_DIR/completions/$filename" "completions/$filename"
    fi
done

# Link functions (but not Tide functions - they're managed by Fisher)
echo "Linking custom functions..."
for file in "$DOTFILES_DIR/fish/functions"/*.fish; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        # Skip Tide functions - they're installed via Fisher
        if [[ "$filename" != _tide_* ]] && [[ "$filename" != tide.fish ]]; then
            link_file "$file" "$FISH_CONFIG_DIR/functions/$filename" "functions/$filename"
        fi
    fi
done

# Copy fish_plugins (don't symlink - Fisher modifies it)
if [ -f "$DOTFILES_DIR/fish/fish_plugins" ]; then
    if [ ! -f "$FISH_CONFIG_DIR/fish_plugins" ] || ! diff -q "$DOTFILES_DIR/fish/fish_plugins" "$FISH_CONFIG_DIR/fish_plugins" > /dev/null 2>&1; then
        cp "$DOTFILES_DIR/fish/fish_plugins" "$FISH_CONFIG_DIR/fish_plugins"
        echo "  ✓ Copied fish_plugins"
    else
        echo "  ✓ fish_plugins already synced"
    fi
fi

echo ""
echo "✓ Fish configuration synced!"
echo ""
echo "Next steps:"
echo "  1. Install Fisher plugins: fisher install < ~/.config/fish/fish_plugins"
echo "  2. Import Tide config: fish $DOTFILES_DIR/fish/scripts/import-tide-config.fish"

