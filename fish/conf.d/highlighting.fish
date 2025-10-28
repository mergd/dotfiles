# Git output colors
git config --global color.ui auto
git config --global color.status auto
git config --global color.diff auto
git config --global color.branch auto

# Fish syntax highlighting
set fish_color_valid_path --underline
set fish_color_link cyan

# Tide backup and restore functions
function tide_backup -d "Backup Tide prompt configuration"
    set -l backup_dir ~/.config/fish/backups
    mkdir -p $backup_dir
    
    set -l timestamp (date +%Y%m%d_%H%M%S)
    set -l backup_file "$backup_dir/tide_config_$timestamp.fish"
    
    echo "# Tide configuration backup from $timestamp" > $backup_file
    echo "set -gx _tide_left_items $_tide_left_items" >> $backup_file
    echo "set -gx _tide_right_items $_tide_right_items" >> $backup_file
    
    echo "✓ Tide configuration backed up to $backup_file"
end

function tide_restore -d "Restore Tide configuration from backup"
    set -l backup_dir ~/.config/fish/backups
    if not test -d $backup_dir
        echo "No backups found"
        return 1
    end
    
    set -l latest (ls -t "$backup_dir" | head -1)
    if test -z $latest
        echo "No backup files found"
        return 1
    end
    
    source "$backup_dir/$latest"
    echo "✓ Restored from $latest"
end
