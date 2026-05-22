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

AI_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

OLLAMA_MODELS=(
    "qwen3:8b"
    "qwen2.5-coder:3b"
    "qwen2.5-coder:14b"
)

# ─── Python check ─────────────────────────────────────────────────────────────
check_python() {
    if command -v python3 &>/dev/null; then
        success "Python3 found ($(python3 --version))"
        return 0
    fi

    error "Python3 is required for uvx / duckduckgo-mcp-server but was not found."
    echo ""

    local installed=false

    if command -v brew &>/dev/null; then
        echo -en "  ${BOLD}Install Python3 via Homebrew? [y/N]:${RESET} "
        read -r choice && echo ""
        [[ "$choice" =~ ^[Yy]$ ]] && brew install python3 && installed=true
    elif command -v apt &>/dev/null; then
        echo -en "  ${BOLD}Install Python3 via apt? [y/N]:${RESET} "
        read -r choice && echo ""
        [[ "$choice" =~ ^[Yy]$ ]] && sudo apt-get install -y python3 && installed=true
    elif command -v pacman &>/dev/null; then
        echo -en "  ${BOLD}Install Python3 via pacman? [y/N]:${RESET} "
        read -r choice && echo ""
        [[ "$choice" =~ ^[Yy]$ ]] && sudo pacman -S --noconfirm python && installed=true
    else
        error "No supported package manager found. Install Python3 manually: https://python.org"
        exit 1
    fi

    if ! command -v python3 &>/dev/null; then
        error "Python3 still not found. Re-run this script after installing Python3."
        exit 1
    fi

    success "Python3 installed ($(python3 --version))"
}

# ─── Install uv / uvx ────────────────────────────────────────────────────────
install_uv() {
    if command -v uvx &>/dev/null; then
        success "uvx already installed"
        return 0
    fi

    info "Installing uv (provides uvx for duckduckgo-mcp-server)..."
    curl -LsSf https://astral.sh/uv/install.sh | sh

    # Make uvx available in current session
    export PATH="$HOME/.local/bin:$PATH"

    if command -v uvx &>/dev/null; then
        success "uvx installed"
    else
        warn "uvx may need a shell restart to be found"
    fi
}

# ─── Install Ollama ───────────────────────────────────────────────────────────
install_ollama() {
    if command -v ollama &>/dev/null; then
        success "Ollama already installed"
        return 0
    fi

    info "Installing Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh

    if command -v ollama &>/dev/null; then
        success "Ollama installed"
    else
        error "Ollama installation failed"
        return 1
    fi
}

# ─── Install opencode ─────────────────────────────────────────────────────────
install_opencode() {
    if command -v opencode &>/dev/null; then
        success "opencode already installed"
        return 0
    fi

    info "Installing opencode..."
    curl -fsSL https://opencode.ai/install | bash

    if command -v opencode &>/dev/null; then
        success "opencode installed"
    else
        warn "opencode may need a shell restart to be found"
    fi
}

# ─── Deploy opencode configs ──────────────────────────────────────────────────
deploy_opencode_configs() {
    local src="$AI_DIR/.config/opencode"
    local dest="$HOME/.config/opencode"

    if [[ ! -d "$src" || -z "$(ls -A "$src")" ]]; then
        warn "No opencode configs found in $src — skipping"
        return 0
    fi

    if [[ -d "$dest" && -n "$(ls -A "$dest")" ]]; then
        success "opencode configs already exist — skipping"
        return 0
    fi

    info "Copying opencode configs..."
    mkdir -p "$dest"
    cp -r "$src/." "$dest/"
    success "opencode configs copied to $dest"
}

# ─── Pull Ollama models ───────────────────────────────────────────────────────
pull_models() {
    echo -en "  ${BOLD}Pull Ollama models? (qwen3:8b, qwen2.5-coder:3b, qwen2.5-coder:14b) [y/N]:${RESET} "
    read -r pull_choice
    echo ""

    if [[ ! "$pull_choice" =~ ^[Yy]$ ]]; then
        info "Skipping model downloads"
        return 0
    fi

    for model in "${OLLAMA_MODELS[@]}"; do
        if ollama list 2>/dev/null | grep -q "^${model}"; then
            success "$model already pulled"
            continue
        fi

        info "Pulling ${BOLD}${model}${RESET}..."
        if ollama pull "$model"; then
            success "$model ready"
        else
            error "Failed to pull $model"
        fi
        echo ""
    done
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
    echo ""
    echo -e "${CYAN}${BOLD}  🤖 AI Environment Setup${RESET}"
    echo ""

    check_python
    echo ""

    install_uv
    echo ""

    install_ollama
    echo ""

    install_opencode
    echo ""

    deploy_opencode_configs
    echo ""

    pull_models

    echo ""
    success "AI environment ready. Restart your terminal if needed."
}

main
