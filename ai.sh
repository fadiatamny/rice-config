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

# Central, non-secret configuration for the rice installers. Values in .env are
# exported so they are also available to the installers and runtimes they start.
load_env() {
    local env_file="$AI_DIR/.env"

    [[ -f "$env_file" ]] || return 0
    # shellcheck disable=SC1090
    set -a && source "$env_file" && set +a
}

UPDATE_MODE=false

usage() {
    echo "Usage: $(basename "$0") [--update]"
    echo "  --update  Replace managed OpenCode and AI-development configuration only."
}

for arg in "$@"; do
    case "$arg" in
        --update) UPDATE_MODE=true ;;
        -h|--help) usage; exit 0 ;;
        *) error "Unknown option: $arg"; usage; exit 1 ;;
    esac
done

# Configuration-only updates do not install or configure runtimes, so they do
# not need the environment file.
if [[ "$UPDATE_MODE" != true ]]; then
    load_env
fi

default_ollama_models_dir() {
    if [[ -d /mnt && -w /mnt ]]; then
        printf '%s\n' "/mnt/ollama-models"
    else
        printf '%s\n' "$HOME/.ollama/models"
    fi
}

# OLLAMA_MODELS is the environment variable read by Ollama itself. Keep the
# *_DIR name as the user-facing setting so it is not confused with model tags.
OLLAMA_MODELS_DIR="${OLLAMA_MODELS_DIR:-${OLLAMA_MODELS:-$(default_ollama_models_dir)}}"
export OLLAMA_MODELS="$OLLAMA_MODELS_DIR"

# Override with a space-separated list, for example:
# OLLAMA_MODEL_TAGS="qwen3.8:27b qwen3.5:9b gemma4:e4b" ./ai.sh
OLLAMA_MODEL_TAGS="${OLLAMA_MODEL_TAGS:-qwen3.8:27b qwen3.5:9b gemma4:e4b}"
read -r -a OLLAMA_MODEL_LIST <<< "$OLLAMA_MODEL_TAGS"

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

# ─── Configure Ollama model storage ──────────────────────────────────────────
configure_ollama_model_storage() {
    export OLLAMA_MODELS="$OLLAMA_MODELS_DIR"

    if [[ "$(uname -s)" != "Linux" ]] || ! command -v systemctl &>/dev/null; then
        mkdir -p "$OLLAMA_MODELS_DIR"
        info "Ollama models will be stored in $OLLAMA_MODELS_DIR for this setup run."
        warn "Set OLLAMA_MODELS=$OLLAMA_MODELS_DIR in the Ollama service environment to persist it."
        return
    fi

    if ! systemctl cat ollama.service &>/dev/null; then
        mkdir -p "$OLLAMA_MODELS_DIR"
        info "Ollama models will be stored in $OLLAMA_MODELS_DIR for this setup run."
        warn "No system Ollama service found; persist OLLAMA_MODELS in the service that runs Ollama."
        return
    fi

    local service_user service_group
    service_user="$(systemctl show --property=User --value ollama.service)"
    service_user="${service_user:-root}"
    service_group="$(id -gn "$service_user")"

    info "Configuring Ollama model storage at $OLLAMA_MODELS_DIR..."
    sudo install -d -m 0755 -o "$service_user" -g "$service_group" "$OLLAMA_MODELS_DIR"
    sudo install -d -m 0755 /etc/systemd/system/ollama.service.d
    printf '[Service]\nEnvironment="OLLAMA_MODELS=%s"\n' "$OLLAMA_MODELS_DIR" |
        sudo tee /etc/systemd/system/ollama.service.d/override.conf >/dev/null
    sudo systemctl daemon-reload

    if systemctl is-active --quiet ollama.service; then
        sudo systemctl restart ollama.service
    fi

    success "Ollama models will be stored in $OLLAMA_MODELS_DIR"
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

# ─── Deploy OpenCode configuration ────────────────────────────────────────────
cleanup_legacy_opencode() {
    local dest="$1"
    local agents_dest="$dest/agents"

    # Only remove paths previously managed by this repository.
    rm -rf "$dest/skills/fadi"
    rmdir "$dest/skills" 2>/dev/null || true
    rm -f "$agents_dest/orchestrator.md"
    rm -f "$agents_dest/architect.md"
    rm -f "$agents_dest/developer.md"
    rm -f "$agents_dest/reviewer.md"
    rm -f "$agents_dest/janitor.md"
    rm -f "$agents_dest/summarizer.md"
    rm -f "$agents_dest/requirements-analyst.md"
    rm -f "$agents_dest/implementation-worker.md"
}

deploy_opencode_configs() {
    local src="$AI_DIR/.config/opencode"
    local dest="$HOME/.config/opencode"

    if [[ ! -d "$src" || -z "$(ls -A "$src")" ]]; then
        warn "No opencode configs found in $src — skipping"
        return 0
    fi

    if [[ "$UPDATE_MODE" == true ]]; then
        info "Updating managed OpenCode configuration..."
        mkdir -p "$dest"
        cleanup_legacy_opencode "$dest"
        cp -r "$src/." "$dest/"
        success "Managed OpenCode configuration updated"
    else
        info "Adding missing OpenCode configs..."
        mkdir -p "$dest"
        cp -R -n "$src/." "$dest/"
        success "Missing OpenCode configs added to $dest"
    fi
}

# ─── Deploy AI development definitions ────────────────────────────────────────
deploy_ai_development() {
    local src="$AI_DIR/.ai-development"
    local dest="$HOME/.ai-development"
    local agents_src="$dest/agents"
    local agents_dest="$HOME/.config/opencode/agents"
    local agent_file persona_file agent_name target

    if [[ ! -d "$src" || -z "$(ls -A "$src")" ]]; then
        warn "No AI development definitions found in $src — skipping"
        return 0
    fi

    if [[ "$UPDATE_MODE" == true ]]; then
        info "Replacing managed AI development definitions..."
        rm -rf "$dest"
        mkdir -p "$dest"
        cp -r "$src/." "$dest/"
        success "Managed AI development definitions updated"
    else
        info "Adding missing AI development definitions..."
        mkdir -p "$dest"
        cp -R -n "$src/." "$dest/"
        success "Missing AI development definitions added to $dest"
    fi

    mkdir -p "$HOME/.config/opencode"
    mkdir -p "$agents_dest"

    for agent_file in "$agents_src"/*/AGENT.md; do
        [[ -f "$agent_file" ]] || continue
        persona_file="$(dirname "$agent_file")/PERSONA.md"
        agent_name="$(basename "$(dirname "$agent_file")")"
        target="$agents_dest/$agent_name.md"

        if [[ ! -f "$persona_file" ]]; then
            warn "Missing persona for $agent_name — skipping"
        elif [[ -e "$target" && "$UPDATE_MODE" != true ]]; then
            success "OpenCode agent $agent_name already exists — preserving"
        else
            {
                cat "$agent_file"
                echo ""
                cat "$persona_file"
            } > "$target"
            success "Generated OpenCode agent $agent_name"
        fi
    done
}

# ─── Pull Ollama models ───────────────────────────────────────────────────────
pull_models() {
    echo -en "  ${BOLD}Pull Ollama models? (${OLLAMA_MODEL_TAGS}) [y/N]:${RESET} "
    read -r pull_choice
    echo ""

    if [[ ! "$pull_choice" =~ ^[Yy]$ ]]; then
        info "Skipping model downloads"
        return 0
    fi

    for model in "${OLLAMA_MODEL_LIST[@]}"; do
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

    if [[ "$UPDATE_MODE" == true ]]; then
        info "Updating managed AI configuration only..."
        deploy_opencode_configs
        deploy_ai_development
        success "Managed AI configuration updated. OpenCode reloads active configuration automatically."
        return
    fi

    check_python
    echo ""

    install_uv
    echo ""

    install_ollama
    echo ""

    configure_ollama_model_storage
    echo ""

    install_opencode
    echo ""

    deploy_opencode_configs
    echo ""

    deploy_ai_development
    echo ""

    pull_models

    echo ""
    success "AI environment ready. Restart your terminal if needed."
}

main
