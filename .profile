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

encode () {
  echo "$1" | base64
}
decode () {
  echo "$1" | base64 -d
}

