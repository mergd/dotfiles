# Cursor Settings

Symlinked configuration for Cursor editor.

## Setup on New Machine

```bash


# Create symlinks
ln -sf ~/dotfiles/cursor/settings.json ~/Library/Application\ Support/Cursor/User/settings.json
ln -sf ~/dotfiles/cursor/keybindings.json ~/Library/Application\ Support/Cursor/User/keybindings.json
ln -sf ~/dotfiles/cursor/snippets ~/Library/Application\ Support/Cursor/User/snippets

# Install extensions
cat ~/dotfiles/cursor/extensions.txt | xargs -L 1 cursor --install-extension
```

## Update Extensions List

When you install new extensions, update the list:

```bash
cursor --list-extensions > ~/dotfiles/cursor/extensions.txt
cd ~/dotfiles
git add cursor/extensions.txt
git commit -m "Update Cursor extensions"
git push
```

## What's Synced

- `settings.json` - Editor settings
- `keybindings.json` - Keyboard shortcuts
- `snippets/` - Code snippets
- `extensions.txt` - Installed extensions list
