#!/usr/bin/env fish
# Export Tide configuration from universal variables to a portable file
# This reads from fish_variables and converts SETUVAR format to Fish set commands

set -l script_dir (dirname (status --current-filename))
set -l dotfiles_dir (dirname $script_dir)
set -l config_file "$dotfiles_dir/tide_config.fish"
set -l fish_vars_file ~/.config/fish/fish_variables

echo "Exporting Tide configuration..."

if not test -f $fish_vars_file
    echo "Error: fish_variables file not found: $fish_vars_file"
    exit 1
end

# Write header
echo "# Tide configuration exported on "(date) > $config_file
echo "# This file is portable and can be synced across machines" >> $config_file
echo "# Source this file to import Tide configuration" >> $config_file
echo "" >> $config_file

# Extract Tide variables and convert SETUVAR to set -U
# We'll use a temp file to process the values properly
set -l temp_file (mktemp)
grep "^SETUVAR _tide" $fish_vars_file > $temp_file

while read -l line
    # Parse SETUVAR format: SETUVAR var_name:value
    set -l parts (string split -m 1 ":" $line)
    set -l var_name (string replace "SETUVAR " "" $parts[1])
    set -l var_value $parts[2]
    
    # Convert SETUVAR to set -U command
    # The value format in fish_variables uses \x1e for array separators
    # We'll write it as-is and let Fish handle it when sourcing
    echo "set -U $var_name $var_value" >> $config_file
end < $temp_file

rm $temp_file

set -l count (grep -c "^set -U _tide" $config_file 2>/dev/null || echo "0")
echo "✓ Tide configuration exported to $config_file"
echo "  Found $count configuration variables"
echo ""
echo "Note: The exported file uses the same format as fish_variables."
echo "To import, source the file: source $config_file"
