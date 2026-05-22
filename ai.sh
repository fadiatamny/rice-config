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

    info "Copying opencode configs..."
    mkdir -p "$dest"
    cp -r "$src/." "$dest/"
    success "opencode configs copied to $dest"
}

# ─── Pull Ollama models ───────────────────────────────────────────────────────
pull_models() {
    info "Pulling Ollama models..."
    echo ""

    for model in "${OLLAMA_MODELS[@]}"; do
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

    install_ollama
    echo ""

    install_opencode
    echo ""

    deploy_opencode_configs
    echo ""

    echo -en "  ${BOLD}Pull Ollama models? (qwen3:8b, qwen2.5-coder:3b, qwen2.5-coder:14b) [y/N]:${RESET} "
    read -r pull_choice
    echo ""

    if [[ "$pull_choice" =~ ^[Yy]$ ]]; then
        pull_models
    else
        info "Skipping model downloads"
    fi

    echo ""
    success "AI environment ready. Restart your terminal if needed."
}

main
