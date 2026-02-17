# ─── OS Detection ─────────────────────────────────────────────────────────────
if [[ "$OSTYPE" == "darwin"* ]]; then
    _OS="macos"
else
    _OS="linux"
fi

# ─── System Info Function ─────────────────────────────────────────────────────
sys_info() {
    # Colors
    local reset="\e[0m"
    local bold="\e[1m"
    local dim="\e[2m"
    local red="\e[31m"
    local green="\e[32m"
    local yellow="\e[33m"
    local blue="\e[34m"
    local magenta="\e[35m"
    local cyan="\e[36m"

    # Common info
    local user=$(whoami)
    local host=$(hostname | sed 's/\.local$//')
    local kernel=$(uname -r)
    local shell=$(basename "$SHELL")
    local term=$TERM

    # OS-specific info
    local distro cpu memory disk ip uptime_str packages

    if [[ "$_OS" == "macos" ]]; then
        distro="macOS $(sw_vers -productVersion)"
        cpu=$(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "N/A")
        local mem_total=$(( $(sysctl -n hw.memsize 2>/dev/null) / 1073741824 ))
        local mem_used=$(vm_stat 2>/dev/null | awk '
            /Pages active/      { active = $NF+0 }
            /Pages wired/       { wired  = $NF+0 }
            /Pages speculative/ { spec   = $NF+0 }
            /Pages compressed/  { comp   = $NF+0 }
            END { printf "%.1f", (active + wired + spec + comp) * 4096 / 1073741824 }
        ')
        memory="${mem_used}Gi/${mem_total}Gi"
        disk=$(df -h / | awk 'NR==2 {print $3 "/" $2}')
        ip=$(ipconfig getifaddr en0 2>/dev/null || echo "")
        uptime_str=$(uptime | sed -E 's/.*up +//' | sed -E 's/,.*users?.*//' | sed 's/^ *//')
        packages=$(if command -v brew >/dev/null; then brew list --formula 2>/dev/null | wc -l | tr -d ' '; else echo "N/A"; fi)
    else
        distro=$(grep "^NAME=" /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"')
        cpu=$(grep "model name" /proc/cpuinfo 2>/dev/null | head -1 | cut -d: -f2 | sed 's/^[ \t]*//')
        memory=$(free -h 2>/dev/null | awk '/^Mem:/ {print $3 "/" $2}')
        disk=$(df -h / | awk 'NR==2 {print $3 "/" $2}')
        ip=$(ip -4 addr show 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v "127.0.0.1" | head -1)
        uptime_str=$(uptime -p 2>/dev/null | sed 's/up //')
        packages=$(
            if command -v pacman >/dev/null; then pacman -Q 2>/dev/null | wc -l;
            elif command -v dpkg >/dev/null; then dpkg --get-selections 2>/dev/null | wc -l;
            elif command -v rpm >/dev/null; then rpm -qa 2>/dev/null | wc -l;
            else echo "N/A"; fi
        )
    fi

    echo ""
    echo -e "${cyan}${bold}╭───────────────────────────────────────────────────────────────────────╮${reset}"
    echo -e "${cyan}${bold}│${reset} ${green}${bold} Welcome back, ${user}!${reset} ${dim}(${host})${reset}"
    echo -e "${cyan}${bold}├───────────────────────────────────────────────────────────────────────┤${reset}"
    echo -e "${cyan}${bold}│${reset} ${magenta}${bold}●${reset} ${bold}OS:${reset}       ${distro} $(uname -m)"
    echo -e "${cyan}${bold}│${reset} ${blue}${bold}●${reset} ${bold}Kernel:${reset}   ${kernel}"
    echo -e "${cyan}${bold}│${reset} ${yellow}${bold}●${reset} ${bold}Uptime:${reset}   ${uptime_str}"
    echo -e "${cyan}${bold}│${reset} ${red}${bold}●${reset} ${bold}Packages:${reset} ${packages}"
    echo -e "${cyan}${bold}│${reset} ${green}${bold}●${reset} ${bold}Shell:${reset}    ${shell}"
    echo -e "${cyan}${bold}│${reset} ${cyan}${bold}●${reset} ${bold}Terminal:${reset} ${term}"
    echo -e "${cyan}${bold}├───────────────────────────────────────────────────────────────────────┤${reset}"
    echo -e "${cyan}${bold}│${reset} ${yellow}${bold}●${reset} ${bold}CPU:${reset}      ${cpu}"
    echo -e "${cyan}${bold}│${reset} ${green}${bold}●${reset} ${bold}Memory:${reset}   ${memory}"
    echo -e "${cyan}${bold}│${reset} ${magenta}${bold}●${reset} ${bold}Disk:${reset}     ${disk}"
    echo -e "${cyan}${bold}│${reset} ${blue}${bold}●${reset} ${bold}IP:${reset}       ${ip:-Not connected}"
    echo -e "${cyan}${bold}╰───────────────────────────────────────────────────────────────────────╯${reset}"
    echo ""
}

# Display system information on terminal startup
sys_info

# ─── Source Profile ───────────────────────────────────────────────────────────
if [ -f ~/.profile ]; then
    . ~/.profile
fi

# ─── PATH ─────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ─── SSH Agent ────────────────────────────────────────────────────────────────
# macOS manages ssh-agent via Keychain, only start manually on Linux
if [[ "$_OS" == "linux" ]]; then
    eval "$(ssh-agent -s)" > /dev/null
fi

# ─── Zinit ────────────────────────────────────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"

zinit ice as"command" from"gh-r" mv"oh-my-posh* -> oh-my-posh" pick"oh-my-posh"
zinit light jandedobbeleer/oh-my-posh

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit snippet OMZP::command-not-found

autoload -U compinit

# Rebuild completion cache if needed
if [[ -n "$ZSH_COMPDUMP" ]]; then
    compinit -C -d "$ZSH_COMPDUMP"
else
    compinit -C
fi

zinit cdreplay -q

# ─── Key Bindings ─────────────────────────────────────────────────────────────
autoload -Uz edit-command-line
zle      -N edit-command-line
bindkey '^X^E' edit-command-line

# ─── Oh My Posh ──────────────────────────────────────────────────────────────
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/tokyonight.omp.json)"

# ─── History ──────────────────────────────────────────────────────────────────
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# ─── Completion Styles ───────────────────────────────────────────────────────
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'
zstyle ':completion:*' menu no

# fzf-tab previews — use cross-platform ls coloring
if [[ "$_OS" == "macos" ]]; then
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -G $realpath'
    zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls -G $realpath'
else
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
    zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
fi

# ─── FZF & Zoxide ─────────────────────────────────────────────────────────────
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# ─── NVM ──────────────────────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
if [[ "$_OS" == "macos" ]]; then
    # Homebrew installs nvm here
    [ -s "$(brew --prefix 2>/dev/null)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh"
    [ -s "$(brew --prefix 2>/dev/null)/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"
fi
# Standard nvm locations (works on both, falls through if not found)
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ─── GVM (Go Version Manager) ────────────────────────────────────────────────
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# ─── Conda ────────────────────────────────────────────────────────────────────
# Try common conda locations
_conda_bin=""
if [[ -f "$HOME/miniconda3/bin/conda" ]]; then
    _conda_bin="$HOME/miniconda3/bin/conda"
elif [[ -f "$HOME/anaconda3/bin/conda" ]]; then
    _conda_bin="$HOME/anaconda3/bin/conda"
elif [[ -f "/opt/homebrew/Caskroom/miniconda/base/bin/conda" ]]; then
    _conda_bin="/opt/homebrew/Caskroom/miniconda/base/bin/conda"
fi

if [[ -n "$_conda_bin" ]]; then
    __conda_setup="$("$_conda_bin" 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        _conda_dir="$(dirname "$(dirname "$_conda_bin")")"
        if [ -f "$_conda_dir/etc/profile.d/conda.sh" ]; then
            . "$_conda_dir/etc/profile.d/conda.sh"
        else
            export PATH="$_conda_dir/bin:$PATH"
        fi
    fi
    unset __conda_setup _conda_dir
fi
unset _conda_bin