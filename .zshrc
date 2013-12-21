HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

#autoload -U colors && colors
#export PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}$ "
export PS1=$'%{\e[1;32m%}%n%{\e[0m%}@%{\e[1;34m%}%m %{\e[1;33m%}%~ %{\e[0m%}$ '

bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall

autoload -Uz compinit
compinit
# End of lines added by compinstall
alias ypu='cd ~/src/yp-engineering/yp'
alias ls='/bin/ls --color'
alias ll='ls -ahl'
alias grep='grep --colour=auto'

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

setopt autocd

zstyle :compinstall filename '/home/njones/.zshrc'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

