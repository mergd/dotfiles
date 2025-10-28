#!/usr/bin/env bash
# This script should be idempotent
set -e

WORK_MODE=false
DRY_RUN=false

RESET="\033[0m"
BOLD="\033[1m"
GREEN="\033[32m"
BLUE="\033[34m"
YELLOW="\033[33m"
RED="\033[31m"

print_header() {
    echo -e "\n${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${BOLD}${BLUE}  $1${RESET}"
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
}

print_success() {
    echo -e "${GREEN}✓${RESET} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${RESET} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${RESET} $1"
}

print_error() {
    echo -e "${RED}✗${RESET} $1"
}

show_help() {
    cat << EOF
${BOLD}macOS Setup Script${RESET}

${BOLD}USAGE:${RESET}
    ./setup-mac.sh [OPTIONS]

${BOLD}OPTIONS:${RESET}
    -w, --work          Work mode (excludes social apps)
    -d, --dry-run       Show what would be installed without installing
    -h, --help          Show this help message

${BOLD}APPS INSTALLED:${RESET}
    Productivity:   Notion, Raycast, CleanShot, Dropover, 1Password, Clipy
    Communication:  Slack, Zoom, WhatsApp*, Discord*, Telegram*
    Browsers:       Arc, Chrome
    Development:    Ghostty, Postico
    Learning:       Anki
    Music:          Spotify*
    
    CLI Tools:      git, gh, jq, ripgrep, fzf, bat, eza, htop, wget,
                    fd, tree, glow, neovim, tmux, git-delta, httpie,
                    lazygit, zoxide, direnv, starship

    * Excluded in work mode

EOF
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -w|--work)
            WORK_MODE=true
            shift
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

print_header "macOS Setup Script"

if $WORK_MODE; then
    print_info "Running in ${BOLD}work mode${RESET} - social apps will be skipped"
fi

if $DRY_RUN; then
    print_warning "Running in ${BOLD}dry-run mode${RESET} - no changes will be made"
fi

if ! command -v brew &> /dev/null; then
    print_error "Homebrew is not installed. Please install it first:"
    echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

print_success "Homebrew is installed"

print_header "Updating Homebrew"
if $DRY_RUN; then
    print_info "Would update Homebrew"
else
    brew update
    print_success "Homebrew updated"
fi

is_app_installed() {
    local app_name=$1
    
    case "$app_name" in
        "1password")
            [ -d "/Applications/1Password.app" ] || [ -d "$HOME/Applications/1Password.app" ]
            ;;
        "google-chrome")
            [ -d "/Applications/Google Chrome.app" ] || [ -d "$HOME/Applications/Google Chrome.app" ]
            ;;
        "cleanshot")
            [ -d "/Applications/CleanShot X.app" ] || [ -d "$HOME/Applications/CleanShot X.app" ]
            ;;
        "notion")
            [ -d "/Applications/Notion.app" ] || [ -d "$HOME/Applications/Notion.app" ]
            ;;
        "raycast")
            [ -d "/Applications/Raycast.app" ] || [ -d "$HOME/Applications/Raycast.app" ]
            ;;
        "anki")
            [ -d "/Applications/Anki.app" ] || [ -d "$HOME/Applications/Anki.app" ]
            ;;
        "slack")
            [ -d "/Applications/Slack.app" ] || [ -d "$HOME/Applications/Slack.app" ]
            ;;
        "zoom")
            [ -d "/Applications/zoom.us.app" ] || [ -d "$HOME/Applications/zoom.us.app" ]
            ;;
        "whatsapp")
            [ -d "/Applications/WhatsApp.app" ] || [ -d "$HOME/Applications/WhatsApp.app" ]
            ;;
        "discord")
            [ -d "/Applications/Discord.app" ] || [ -d "$HOME/Applications/Discord.app" ]
            ;;
        "arc")
            [ -d "/Applications/Arc.app" ] || [ -d "$HOME/Applications/Arc.app" ]
            ;;
        "ghostty")
            [ -d "/Applications/Ghostty.app" ] || [ -d "$HOME/Applications/Ghostty.app" ]
            ;;
        "postico")
            [ -d "/Applications/Postico.app" ] || [ -d "$HOME/Applications/Postico.app" ]
            ;;
        "clipy")
            [ -d "/Applications/Clipy.app" ] || [ -d "$HOME/Applications/Clipy.app" ]
            ;;
        "spotify")
            [ -d "/Applications/Spotify.app" ] || [ -d "$HOME/Applications/Spotify.app" ]
            ;;
        *)
            local capitalized="$(tr '[:lower:]' '[:upper:]' <<< ${app_name:0:1})${app_name:1}"
            [ -d "/Applications/${capitalized}.app" ] || [ -d "$HOME/Applications/${capitalized}.app" ]
            ;;
    esac
}

PRODUCTIVITY_APPS=(
    "notion"
    "raycast"
    "cleanshot"
    "1password"
    "anki"
    "clipy"
)

COMMUNICATION_APPS=(
    "slack"
    "zoom"
)

SOCIAL_APPS=(
    "whatsapp"
    "discord"
    "spotify"
)

BROWSER_APPS=(
    "arc"
    "google-chrome"
)

DEV_APPS=(
    "ghostty"
    "postico"
)

BREW_UTILS=(
    "git"
    "gh"
    "jq"
    "ripgrep"
    "fzf"
    "bat"
    "eza"
    "htop"
    "wget"
    "fd"
    "tree"
    "glow"
    "neovim"
    "tmux"
    "git-delta"
    "httpie"
    "lazygit"
    "zoxide"
    "direnv"
    "starship"
)

install_brew_utils() {
    print_header "Installing Homebrew Utilities"
    
    for util in "${BREW_UTILS[@]}"; do
        if brew list "$util" &> /dev/null; then
            print_warning "$util is already installed"
        else
            if $DRY_RUN; then
                print_info "Would install: $util"
            else
                print_info "Installing $util..."
                brew install "$util"
                print_success "$util installed"
            fi
        fi
    done
}

install_cask_apps() {
    local category=$1
    shift
    local apps=("$@")
    
    if [ ${#apps[@]} -eq 0 ]; then
        return
    fi
    
    print_header "Installing $category"
    
    for app in "${apps[@]}"; do
        if is_app_installed "$app"; then
            print_warning "$app is already installed"
        else
            if $DRY_RUN; then
                print_info "Would install: $app"
            else
                print_info "Installing $app..."
                brew install --cask "$app"
                print_success "$app installed"
            fi
        fi
    done
}

install_brew_utils

install_cask_apps "Productivity Apps" "${PRODUCTIVITY_APPS[@]}"
install_cask_apps "Communication Apps" "${COMMUNICATION_APPS[@]}"

if ! $WORK_MODE; then
    install_cask_apps "Social Apps" "${SOCIAL_APPS[@]}"
else
    print_info "Skipping social apps (work mode enabled)"
fi

install_cask_apps "Browsers" "${BROWSER_APPS[@]}"
install_cask_apps "Development Tools" "${DEV_APPS[@]}"

print_header "Mac App Store Apps"

if ! command -v mas &> /dev/null; then
    print_warning "mas-cli is not installed. Installing it now..."
    if $DRY_RUN; then
        print_info "Would install: mas"
    else
        brew install mas
        print_success "mas-cli installed"
    fi
fi

is_mas_app_installed() {
    local app_name=$1
    if command -v mas &> /dev/null; then
        mas list | grep -i "$app_name" &> /dev/null
    else
        return 1
    fi
}

if command -v mas &> /dev/null || $DRY_RUN; then
    print_warning "Note: You must be signed in to the App Store first"
    
    MAS_APPS=("dropover")
    MAS_SOCIAL_APPS=("telegram")
    
    for app in "${MAS_APPS[@]}"; do
        if is_mas_app_installed "$app"; then
            print_warning "$app is already installed"
        elif $DRY_RUN; then
            print_info "Would install $app from Mac App Store"
        else
            read -p "Install $app from Mac App Store? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                mas lucky "$app" || print_warning "Failed to install $app. You may need to sign in to the App Store first."
            fi
        fi
    done
    
    if ! $WORK_MODE; then
        for app in "${MAS_SOCIAL_APPS[@]}"; do
            if is_mas_app_installed "$app"; then
                print_warning "$app is already installed"
            elif $DRY_RUN; then
                print_info "Would install $app from Mac App Store"
            else
                read -p "Install $app from Mac App Store? (y/n) " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    mas lucky "$app" || print_warning "Failed to install $app. You may need to sign in to the App Store first."
                fi
            fi
        done
    else
        print_info "Skipping Telegram (work mode enabled)"
    fi
fi

print_header "Setup Complete!"

if ! $DRY_RUN; then
    print_success "All applications have been installed successfully"
    print_info "You may need to restart some applications or log out and back in"
else
    print_info "Dry-run complete. Run without --dry-run to actually install"
fi

echo ""

