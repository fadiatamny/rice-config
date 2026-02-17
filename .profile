# ─── OS Detection ─────────────────────────────────────────────────────────────
if [[ "$OSTYPE" == "darwin"* ]]; then
    _OS="macos"
else
    _OS="linux"
fi

# ─── Docker Aliases ───────────────────────────────────────────────────────────
alias dc="docker-compose"
alias dcu="docker-compose up -d"

# ─── CPU Frequency (Linux only) ──────────────────────────────────────────────
if [[ "$_OS" == "linux" ]]; then
    alias cpuFreq="watch -n 0.1 'cat /proc/cpuinfo | grep MHz'"
elif [[ "$_OS" == "macos" ]]; then
    alias cpuFreq="echo 'CPU frequency monitoring is not supported on macOS via /proc'"
fi

# ─── ls / eza Aliases ────────────────────────────────────────────────────────
if command -v eza >/dev/null 2>&1; then
    alias l='eza -lh --icons=auto'
    alias ll='eza -lha --icons=auto --sort=name --group-directories-first'
    alias ld='eza -lhD --icons=auto'
    alias lt='eza --icons=auto --tree'
fi

if [[ "$_OS" == "macos" ]]; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi

alias grep='grep --color=auto'

# ─── SSH ──────────────────────────────────────────────────────────────────────
alias ssh-init="~/.ssh/init.sh"

# ─── Encode / Decode ─────────────────────────────────────────────────────────
encode () {
    echo "$1" | base64
}

decode () {
    if [[ "$_OS" == "macos" ]]; then
        echo "$1" | base64 -D
    else
        echo "$1" | base64 -d
    fi
}

# ─── Kill Port ────────────────────────────────────────────────────────────────
kill_port() {
    local port="$1"
    local process=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -n|--name)
                process="$2"
                shift 2
                ;;
            *)
                port="$1"
                shift
                ;;
        esac
    done

    process="${process:-node}"

    echo "Killing ${process} on port ${port}."

    lsof -i :"$port" | grep "$process" | awk '{print $2}' | xargs kill -9
}

# ─── Set Brightness (Linux only, requires ddcutil) ───────────────────────────
set_brightness() {
    if [[ "$_OS" == "macos" ]]; then
        echo "ERROR: set_brightness uses ddcutil which is Linux-only." >&2
        echo "       On macOS, use System Settings or a tool like 'brightness' from Homebrew." >&2
        return 1
    fi

    if ! command -v ddcutil >/dev/null 2>&1; then
        echo "ERROR: ddcutil is not installed." >&2
        return 1
    fi

    local brightness_val="$1"

    # Quick sanity check: is it actually a number between 0 and 100?
    if ! [[ "$brightness_val" =~ ^[0-9]+$ ]] || (( brightness_val < 0 )) || (( brightness_val > 100 )); then
        echo "ERROR: Brightness value must be a number between 0 and 100, you moron." >&2
        return 1
    fi

    echo "Setting brightness for Display 1 and Display 2 to $brightness_val..."

    # Set brightness for display 1
    ddcutil setvcp 10 "$brightness_val" --display 1
    if [ $? -ne 0 ]; then
        echo "WARNING: Failed to set brightness for Display 1. Is it connected and supported?" >&2
    fi

    # Set brightness for display 2
    ddcutil setvcp 10 "$brightness_val" --display 2
    if [ $? -ne 0 ]; then
        echo "WARNING: Failed to set brightness for Display 2. Is it connected and supported?" >&2
    fi

    echo "Brightness adjustment attempted. Check your displays, genius."
}
