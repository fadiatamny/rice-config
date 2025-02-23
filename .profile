alias dc="docker-compose"
alias dcu="docker-compose up -d"
alias cpuFreq="watch -n 0.1 'cat /proc/cpuinfo | grep MHz'"
alias ls="ls --color"
alias grep='grep --color'
alias ll='ls -alF'
alias lgit='lazygit'

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
