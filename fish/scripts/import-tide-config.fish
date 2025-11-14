#!/usr/bin/env fish
# Import Tide configuration from portable file to universal variables
# This reads the tide_config.fish file and sets the universal variables

set -l script_dir (dirname (status --current-filename))
set -l dotfiles_dir (dirname $script_dir)
set -l config_file "$dotfiles_dir/tide_config.fish"

if not test -f $config_file
    echo "Error: Tide config file not found: $config_file"
    echo "Run export-tide-config.fish first to create it"
    exit 1
end

echo "Importing Tide configuration from $config_file..."

# Read and process each line
while read -l line
    # Skip comments and empty lines
    if string match -q "#*" $line; or test -z (string trim $line)
        continue
    end
    
    # Parse the set -U command
    # Format: set -U var_name value
    set -l parts (string split " " $line)
    if test (count $parts) -lt 3; or test "$parts[1]" != "set"; or test "$parts[2]" != "-U"
        continue
    end
    
    set -l var_name $parts[3]
    set -l var_value (string join " " $parts[4..])
    
    # The value contains \x1e as literal string, we need to convert it to actual separator
    # Use printf to interpret the hex escape sequence
    set -l processed_value (printf $var_value)
    
    # Check if it's an array (contains separator character 0x1e)
    if string match -q "*\x1e*" $processed_value
        set -l array_items (string split \x1e $processed_value)
        set -U $var_name $array_items
    else
        set -U $var_name $processed_value
    end
end < $config_file

echo "✓ Tide configuration imported"
echo "Run 'tide reload' to apply changes"
