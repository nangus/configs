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
ls --color 1>/dev/null 2>&1

if [[ $? == 0 ]]; then
  alias ls='/bin/ls --color'
else
  alias ls='/bin/ls -G'
fi

alias ll='ls -ahl'
alias grep='grep --colour=auto'
alias ng='sudo su - nextgen'

alias nj='ssh -l nj9312'
alias ne='ssh -l nextgen'


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
    echo "`git status | grep 'On branch'|sed 's/.*On branch //'`"
}

function git_branch {

    RED="%{$fg[red]%}"
    GREEN="%{$fg[green]%}"
    YELLOW="%{$fg[yellow]%}"

    git rev-parse --git-dir &> /dev/null

    git_status="$(git status 2> /dev/null)"
    branch_pattern="On branch (.*)$"
    remote_pattern="Your branch is (.*) of"
    diverge_pattern="Your branch and (.*) have diverged"
    ahead_pattern="Your branch is ahead of"

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

function node_inpath {
    PAT=`pwd`
    while [[ `echo $PAT` != "" ]]; do
        if $(ls $PAT/.git 1>/dev/null 2>&1) ; then
            if [ `ls $PAT/package.json` ]; then
                echo  -n 'found'
                return
            fi
            echo -n 'not found'
            return
        fi
        PAT=`echo $PAT|sed 's#/[^/]*$##'`
    done
    echo -n 'not found'
}

function correct_node {
    PAT=`pwd`
    while [[ `echo $PAT` != "" ]]; do
        if $(ls $PAT/.git 1>/dev/null 2>&1) ; then
            if [ `ls $PAT/NODE_VERSION 2>/dev/null ` ]; then
                echo -n 'v';
                cat $PAT/NODE_VERSION
                return
            fi
            return
        fi
        PAT=`echo $PAT|sed 's#/[^/]*$##'`
    done
}


function node_version {
    if $(command -v node >/dev/null 2>&1)  ; then
        nodeV=`node -v`
        needV=$(correct_node)
        if [[ $needV != '' ]]; then
          if [[ $nodeV == $needV ]]; then
            echo "| %{$fg[green]%} $nodeV %{$reset_color%} " 2>/dev/null
          else
            echo "| %{$fg[red]%} $nodeV %{$reset_color%} " 2>/dev/null
          fi
        fi
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
    RPROMPT="%{$fg[red]%}${return_code} %{$reset_color%} [${p_git_branch}`node_version||ruby_version`]"
}

autoload -U colors && colors

function setRuby() {
    arr=(`ls --color=no /home/t|grep ruby`)
    i=0
    for s in $arr[@] ; do
        i=$((i + 1))
        echo $i $s
    done
    i=$((i + 1))
    read IN
    if [[ $IN < $i ]]; then
        echo ${arr[$IN]}
        export PATH=/home/t/${arr[$IN]}/bin:$PATH
    else
        echo out of range
    fi
}

#function cleanPath() {
#    CLEAN=`echo $PATH|tr ":" "\n"|sort|uniq|grep -v '/usr/local/bin/'|tr "\n" ":"`
#    MINE=`echo $CLEAN|tr ":" "\n"|grep $(whoami)|tr "\n" ":"`
#    OTHE=`echo $CLEAN|tr ":" "\n"|grep -v $(whoami)|tr "\n" ":"`
#    export PATH=$(echo $MINE:/usr/local/bin/:$OTHE|sed 's#::\+#:#g'|sed 's#:$##'|sed 's#^:##')
#}

zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
export PERLLIB=/home/nj9312/perl/lib64/perl5/site_perl/5.8.8/x86_64-linux-thread-multi/
bindkey ';3D' emacs-backward-word
bindkey ';3C' emacs-forward-word
bindkey 'OH' beginning-of-line
bindkey '[1~' beginning-of-line
bindkey 'OF' end-of-line
bindkey '[4~' end-of-line

export ORACLE_HOME=$HOME/oracle/instantclient_11_2
export LD_LIBRARY_PATH=$ORACLE_HOME:$LD_LIBRARY_PATH
export PATH=$ORACLE_HOME:$PATH
export TNS_ADMIN=$ORACLE_HOME/network/admin
export GOPATH=$HOME/.goLib
mkdir -p $GOPATH
export PATH=/home/t/go/bin:$PATH

export PATH=$PATH:/Users/nj9312/src/android-sdks/tools/
export PATH=$PATH:/Users/nj9312/src/android-sdks/platform-tools

export NVM_DIR="/Users/nj9312/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  nvm 1>/dev/null 2>&1
  HASNVM=$?
  if [[ $HASNVM != 0 ]]; then
    return
  fi
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
    if [[ "$nvmrc_node_version" == "N/A" ]]; then
      nvm install $(cat "${nvmrc_path}")
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

PATH="/Users/nj9312/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/nj9312/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/nj9312/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/nj9312/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/nj9312/perl5"; export PERL_MM_OPT;
export PATH=$PATH:/Users/nj9312/src/android-sdks/tools/
export PATH=$PATH:/Users/nj9312/src/android-sdks/platform-tools
export PATH=/home/t/bin:$PATH
