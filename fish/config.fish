fish_add_path -a /Users/william/.foundry/bin
# Default editor for claude code
set -gx VISUAL code




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
set -gx PNPM_HOME "/Users/william/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# Load environment variables from a .env file
function load_env_vars -d "Load variables from a .env file"
    set lines (cat $argv | string split '\n')
    for line in $lines
        # Skip empty lines and comments
        if test -z "$line"; or string match -q -r '^\s*#' "$line"
            continue
        end
        
        # Remove any inline comments
        set line (string replace -r '\s*#.*$' '' "$line")
        
        # Split into key and value, handling quoted values
        set arr (string split -m 1 '=' "$line")
        if test (count $arr) -eq 2
            # Trim whitespace from both key and value
            set key (string trim "$arr[1]")
            set value (string trim "$arr[2]")
            
            # Handle quoted values (both single and double quotes)
            if string match -q -r '^".*"$' "$value"
                set value (string sub -s 2 -e -1 -- "$value")
            else if string match -q -r "^'.*'\$" "$value"
                set value (string sub -s 2 -e -1 -- "$value")
            end
            
            # Only set if key is valid
            if string match -q -r '^[a-zA-Z_][a-zA-Z0-9_]*$' "$key"
                set -gx "$key" "$value"
            end
        end
    end
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :








