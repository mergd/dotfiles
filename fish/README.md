# Fish Shell Configuration

This directory contains all Fish shell configuration files that should be synced across machines.

## Structure

- `config.fish` - Main Fish configuration file
- `conf.d/` - Configuration snippets loaded automatically
- `completions/` - Command completions
- `functions/` - Custom Fish functions
- `fish_plugins` - List of Fisher plugins to install
- `scripts/` - Utility scripts for managing configs
- `tide_config.fish` - Portable Tide prompt configuration (gitignored, generated)

## Setup on New Machine

### 1. Sync Configuration Files

Run the sync script to link all configs from dotfiles to `~/.config/fish/`:

```bash
cd ~/dotfiles
./fish/sync-fish-configs.sh
```

This will:

- Link all config files from dotfiles to `~/.config/fish/`
- Create necessary directories
- Back up existing files if they exist
- Copy `fish_plugins` file

### 2. Install Fisher Plugins

Install the plugins listed in `fish_plugins`:

```bash
fisher install < ~/.config/fish/fish_plugins
```

Or if Fisher isn't installed:

```bash
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
fisher install < ~/.config/fish/fish_plugins
```

### 3. Import Tide Configuration

Tide configuration is stored in universal variables, which are machine-specific. To sync it:

```bash
fish ~/dotfiles/fish/scripts/import-tide-config.fish
tide reload
```

## Updating Configuration

### Export Tide Config

When you change Tide configuration on one machine, export it to make it portable:

```bash
fish ~/dotfiles/fish/scripts/export-tide-config.fish
```

This creates `fish/tide_config.fish` which can be synced via git.

### Sync Changes

After making changes to config files:

1. Commit changes to dotfiles repo
2. Pull changes on other machines
3. Run `./fish/sync-fish-configs.sh` to update symlinks
4. Run `fish ~/dotfiles/fish/scripts/import-tide-config.fish` if Tide config changed
5. Reload: `source ~/.config/fish/config.fish` or restart terminal

## What's Synced

✅ **Synced via Git:**

- `config.fish` - Main config (uses `$HOME`, portable)
- `conf.d/*.fish` - Configuration snippets
- `completions/*.fish` - Command completions
- `functions/*.fish` - Custom functions (except Tide)
- `fish_plugins` - Plugin list
- `scripts/*.fish` - Utility scripts

❌ **NOT Synced (gitignored):**

- `fish_variables` - Machine-specific universal variables
- `tide_config.fish` - Generated Tide config (can be synced manually)

## Troubleshooting

### Tide Prompt Not Working

1. Make sure Tide is installed: `fisher list | grep tide`
2. Import Tide config: `fish ~/dotfiles/fish/scripts/import-tide-config.fish`
3. Reload: `tide reload`

### Path Issues

All paths in `config.fish` use `$HOME` instead of hardcoded paths. If something doesn't work:

- Check if the directory exists: `test -d $HOME/.foundry/bin`
- The config checks for existence before adding to PATH

### Functions Not Found

Make sure the sync script ran successfully and symlinks are created:

```bash
ls -la ~/.config/fish/functions/ | grep -E "->.*dotfiles"
```

## Notes

- Tide functions are managed by Fisher, not symlinked
- `fish_variables` contains machine-specific paths and shouldn't be synced
- The sync script backs up existing files before overwriting
