#!/usr/bin/env bash
set -euo pipefail

# ─── Colors ───────────────────────────────────────────────────────────────────
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"
BOLD="\033[1m"
RESET="\033[0m"

info()    { echo -e "${CYAN}[INFO]${RESET}  $*"; }
success() { echo -e "${GREEN}[OK]${RESET}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${RESET}  $*"; }
error()   { echo -e "${RED}[ERR]${RESET}   $*"; }

RICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── OS Detection ─────────────────────────────────────────────────────────────
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
else
    OS="linux"
fi

# ─── Homebrew Init (macOS) ────────────────────────────────────────────────────
if [[ "$OS" == "macos" ]]; then
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# ─── Package Manager Detection ───────────────────────────────────────────────
detect_pkg_manager() {
    if command -v brew &>/dev/null; then
        echo "brew"
    elif command -v apt &>/dev/null; then
        echo "apt"
    elif command -v pacman &>/dev/null; then
        echo "pacman"
    else
        echo ""
    fi
}

# ─── Package Install ─────────────────────────────────────────────────────────
pkg_install() {
    local bin_name="$1"
    local pkg_name="${2:-$1}"
    local pkg_mgr
    pkg_mgr="$(detect_pkg_manager)"

    if command -v "$bin_name" &>/dev/null; then
        success "$bin_name already installed"
        return 0
    fi

    case "$pkg_mgr" in
        brew)   brew install "$pkg_name" ;;
        apt)    sudo apt-get install -y "$pkg_name" ;;
        pacman) sudo pacman -S --noconfirm "$pkg_name" ;;
        *)
            error "No supported package manager found (need brew, apt, or pacman)"
            return 1
            ;;
    esac

    if command -v "$bin_name" &>/dev/null; then
        success "$bin_name installed"
    else
        warn "$bin_name may need a shell restart to be found"
    fi
}

# ─── Copy Helper ──────────────────────────────────────────────────────────────
copy_config() {
    local src="$1"
    local dest="$2"

    mkdir -p "$(dirname "$dest")"

    if [[ -d "$src" ]]; then
        cp -r "$src" "$dest"
    else
        cp "$src" "$dest"
    fi

    success "$dest"
}

# ─── Deploy Configs ───────────────────────────────────────────────────────────
deploy_configs() {
    info "Detected OS: ${BOLD}${OS}${RESET}"
    info "Rice directory: ${BOLD}${RICE_DIR}${RESET}"
    echo ""
    info "Copying configs..."
    echo ""

    copy_config "$RICE_DIR/.zshrc"                          "$HOME/.zshrc"
    copy_config "$RICE_DIR/.profile"                        "$HOME/.profile"
    copy_config "$RICE_DIR/.gitconfig"                      "$HOME/.gitconfig"
    copy_config "$RICE_DIR/.ssh/init.sh"                    "$HOME/.ssh/init.sh"
    copy_config "$RICE_DIR/.config/oh-my-posh"              "$HOME/.config/oh-my-posh"
    copy_config "$RICE_DIR/.config/wezterm"                 "$HOME/.config/wezterm"
    copy_config "$RICE_DIR/.config/ghostty"                 "$HOME/.config/ghostty"

    if [[ "$OS" == "macos" ]]; then
        copy_config "$RICE_DIR/.zed" "$HOME/.zed"
    else
        copy_config "$RICE_DIR/.zed" "$HOME/.config/zed"
    fi

    chmod 700 "$HOME/.ssh"
    chmod 755 "$HOME/.ssh/init.sh"

    echo ""
    success "All configs copied. Restart your terminal to apply changes."
}

# ─── Install Homebrew (macOS) ─────────────────────────────────────────────────
install_brew() {
    if command -v brew &>/dev/null; then
        success "Homebrew already installed"
        return 0
    fi

    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to PATH for the current session
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    if command -v brew &>/dev/null; then
        success "Homebrew installed"
    else
        error "Homebrew installation failed"
        return 1
    fi
}

# ─── Install Shell Dependencies ──────────────────────────────────────────────
install_shell_deps() {
    info "Detected OS: ${BOLD}${OS}${RESET}"
    echo ""

    # Install Homebrew first on macOS if not present
    if [[ "$OS" == "macos" ]]; then
        install_brew
    fi

    local pkg_mgr
    pkg_mgr="$(detect_pkg_manager)"

    if [[ -z "$pkg_mgr" ]]; then
        error "No supported package manager found (need brew, apt, or pacman)"
        return 1
    fi

    info "Package manager: ${BOLD}${pkg_mgr}${RESET}"
    echo ""
    info "Installing shell dependencies..."
    echo ""

    pkg_install git
    pkg_install fzf
    pkg_install zoxide
    pkg_install eza
    pkg_install lazygit

    echo ""
    success "Shell dependencies installed. Restart your terminal to apply."
}

# ─── Menu ─────────────────────────────────────────────────────────────────────
show_menu() {
    echo ""
    echo -e "${CYAN}${BOLD}  🍚 Rice Config${RESET}"
    echo ""
    echo "  1) Deploy configs"
    echo "  2) Install shell dependencies"
    echo "  0) Exit"
    echo ""
}

main() {
    while true; do
        show_menu
        echo -en "  ${BOLD}Select an option:${RESET} "
        read -r choice

        echo ""
        case "$choice" in
            1) deploy_configs ;;
            2) install_shell_deps ;;
            0) info "Bye!"; exit 0 ;;
            *) warn "Invalid option" ;;
        esac
    done
}

main