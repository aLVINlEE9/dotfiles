# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export LANG=en_US.UTF-8
export VISUAL=nvim

# PATH configuration
if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Alias
alias vim='nvim'
alias t='tmux'

alias gits='git status'
gitm() { git commit -m "$1" }
alias gitp='git push'

alias nvc='cd $HOME/.config/nvim && vim'

alias cl="clear"

alias lr="ls -lrt"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  colored-man-pages
  colorize
)
# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Load Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Autojump configuration
if [[ "$OSTYPE" == "darwin"* ]]; then
    [ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    [ -f /etc/profile.d/autojump.sh ] && . /etc/profile.d/autojump.sh
fi

# Tmux auto start
if [[ -z "$TMUX" && -n "$PS1" ]]; then
    tmux attach || tmux new-session
fi
