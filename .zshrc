PATH=$PATH:$HOME/.rvm/bin:$HOME/Scripts:$HOME/bin # Add RVM to PATH for scripting

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
#autoload -U colors && colors
#export PS1="$(RED)%n%{\e[0m%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{\e[0m%}$ "
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
alias ng='sudo su - nextgen'

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

setopt autocd

zstyle :compinstall filename '/home/njones/.zshrc'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

###############################################################
# Prompt
###############################################################
function git_branch_string {
    echo "`git status | grep "^# On branch .*$" | cut -d " " -f 4`"
}

function git_branch {

    RED="%{$fg[red]%}"
    GREEN="%{$fg[green]%}"
    YELLOW="%{$fg[yellow]%}"

    git rev-parse --git-dir &> /dev/null

    git_status="$(git status 2> /dev/null)"
    branch_pattern="^# On branch (.*)$"
    remote_pattern="# Your branch is (.*) of"
    diverge_pattern="# Your branch and (.*) have diverged"
    ahead_pattern="^# Your branch is ahead of"

    if [[ ! ${git_status} =~ "working directory clean" ]]; then
        state=" ${RED}⚡"
    fi
    if [[ ${git_status} =~ ${remote_pattern} ]]; then
        if [[ ${git_status} =~ ${ahead_pattern} ]]; then
            remote=" ${YELLOW}↑"
        else
            remote=" ${YELLOW}↓"
        fi
    fi

    if [[ ${git_status} =~ ${diverge_pattern} ]]; then
        remote=" ${YELLOW}↕"
    fi
    if [[ ${git_status} =~ ${branch_pattern} ]]; then
        branch="`git_branch_string`"
        echo " ${branch}${remote}${state}"
    fi

}

function ruby_version {
    if test -f Gemfile || test "$(find . -maxdepth 1 -type f -name "*.rb")"; then
        echo "| %{$fg[red]%}`ruby -v | cut -d " " -f 2`%{$reset_color%} " 2>/dev/null
    fi
}

function node_version {
    if test -f package.json || test "$(find . -maxdepth 1 -type f -name "*.js")"; then
        echo "| %{$fg[green]%}`node -v | cut -d " " -f 2`%{$reset_color%} " 2>/dev/null
    fi
}

if test "$( zsh --version | awk '{print $2}' | awk -F'.' ' ( $1 > 4 || ( $1 == 4 && $2 > 3 ) || ( $1 == 4 && $2 == 3 && $3 >= 17 ) ) ' )"
then
    function zle-line-init zle-keymap-select {
        local old_ps1="${PS1:0:-2}"
        PS1="$old_ps1${${KEYMAP/vicmd/:}/(main|viins)/$} "
        zle reset-prompt
    }
    zle -N zle-line-init
    zle -N zle-keymap-select
fi

function precmd() {
    local p_git_branch="`git_branch`"
    if test "${p_git_branch}"; then
        local p_git_branch="${p_git_branch}%{$reset_color%} "
    else
        local p_git_branch=" %T "
    fi
    local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
    test "$PS_SIGN" || export PS_SIGN="[I] "
    PS1="%{$fg[yellow]%}[%n@%m] %{$fg[blue]%}%~%{$reset_color%} $ "
    RPROMPT="%{$fg[red]%}${return_code} %{$reset_color%} [${p_git_branch}`ruby_version``node_version`]"
}

autoload -U colors && colors

zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
export PERLLIB=/home/nj9312/perl/lib64/perl5/site_perl/5.8.8/x86_64-linux-thread-multi/
