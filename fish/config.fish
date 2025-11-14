# Foundry
if test -d $HOME/.foundry/bin
    fish_add_path -a $HOME/.foundry/bin
end

# Default editor
set -gx VISUAL code
alias code="cursor"

# GCloud project switching
alias gcspprd="gcloud config set project infinite-production-446115"
alias gcspsdbx="gcloud config set project infinite-sandbox-456108"

# API Keys


# Enhanced 'take' command - clones git repo and creates initial folder
function take
    if test (count $argv) -eq 1
        set repo $argv[1]
        set dir (basename $repo | string replace -r '\.git$' '')
    else if test (count $argv) -eq 2
        set repo $argv[1]
        set dir $argv[2]
    else
        echo "Usage: take <repo-url> [directory-name]"
        return 1
    end

    git clone --depth 1 $repo $dir && cd $dir
end

set -g fish_greeting


# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if test -d $PNPM_HOME
    if not string match -q -- $PNPM_HOME $PATH
        set -gx PATH "$PNPM_HOME" $PATH
    end
end

# Load environment variables from a .env file
function fsource -d "Load environment variables from a .env file"
    # Default to .env if no argument provided
    set -l env_file (test (count $argv) -gt 0; and echo $argv[1]; or echo ".env")
    
    if not test -f $env_file
        echo "Error: Environment file '$env_file' not found" >&2
        return 1
    end
    
    # Read file line by line
    while read -l line
        # Skip empty lines and comments
        if test -z "$line"; or string match -q "#*" "$line"
            continue
        end
        
        # Check if line contains an assignment
        if string match -qr '^[[:space:]]*([A-Za-z_][A-Za-z0-9_]*)=(.*)$' "$line"
            set -l parts (string split -m 1 '=' "$line")
            set -l var_name (string trim $parts[1])
            set -l var_value (string trim $parts[2])
            
            # Remove surrounding quotes if present
            if string match -qr '^".*"$' $var_value
                set var_value (string sub -s 2 -e -1 $var_value)
            else if string match -qr "^'.*'\$" $var_value
                set var_value (string sub -s 2 -e -1 $var_value)
            end
            
            # Export the variable
            set -gx $var_name $var_value
        end
    end < $env_file
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :









# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH


# Google Cloud SDK
if test -f "$HOME/Downloads/google-cloud-sdk/path.fish.inc"
    source "$HOME/Downloads/google-cloud-sdk/path.fish.inc"
end
set -gx NODE_ENV development
set -gx NODE_ENV development
set -gx SCARF_ANALYTICS false
set -gx SCARF_ANALYTICS false

# Quick reload config
function rld -d "Reload Fish configuration"
    source ~/.config/fish/config.fish
    echo "🐟 Fish config reloaded!"
end
