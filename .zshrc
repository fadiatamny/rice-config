if [ -f ~/.profile ]; then
    . ~/.profile;
fi

# Arch related
export PATH=$PATH:/home/fadi/.local/bin
eval `ssh-agent -s` > /dev/null

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
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

# Oh my posh config
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/tokyonight.omp.json)"

# History related
HISTFILE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# Zsh completion styling
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Evaluation of plugins
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(thefuck --alias)"
