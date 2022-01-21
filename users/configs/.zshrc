# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
PS1="%{$fg[blue]%}%~%  %{$fg[yellow]%}% | "
#PS1="%{$fg[black]%}%~%  λ "
#PS1="%{$fg[green]%}%~% "$'\n'"λ "
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/zsh/history

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# Load aliases and shortcuts if existent.

alias l="exa -l"
alias ls="ls --color"
alias sl="ls --color"
alias tsm="transmission-remote"
alias nnnp="tmux new-session -s nnnp -n nnn nnn"
alias vim="nvim"
alias spotifyd="spotifyd --no-daemon"
alias mkin="make && sudo make install"
alias pdflatex="xelatex"
alias weather="curl -s 'https://wttr.in/Belo_Horizonte?q&n&p' | head -n -3"


# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.
## case-insensitive (all) completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

fzf-cd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
  ls
}

fzf-kill-processes() {
  local pid
	  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

bindkey -s '^o' 'fzf-cd\n'

bindkey -s '^k' 'fzf-kill-processes\n'

bindkey -s '^a' 'bc -lq\n'

vterm_printf(){
    if [ -n "$TMUX" ] && ([ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ] ); then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

# Load syntax highlighting; should be last.
source /home/basqs/.config/zsh/fast-syntas-highlighting/fast-syntax-highlighting.plugin.zsh
