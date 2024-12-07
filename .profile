# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# if running zsh
if [ -n "$ZSH_VERSION" ]; then
    # include .zshrc if it exists
    if [ -f "$HOME/.zshrc" ]; then
        . "$HOME/.zshrc"
    fi
fi


alias dc="docker-compose"
alias dcu="docker-compose up -d"
alias cpuFreq="watch -n 0.1 'cat /proc/cpuinfo | grep MHz'"
alias ll='ls -alF'

alias ssh-init="~/.ssh/init.sh"

encode () {
  echo "$1" | base64
}
decode () {
  echo "$1" | base64 -d
}

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
