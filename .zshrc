# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="steeef"

ZSH_DISABLE_COMPFIX="true"
# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  yum
  vagrant
  terraform
  brew
  docker
  zsh_reload
  kubectl
  ssh-agent
)

source $ZSH/oh-my-zsh.sh


#Withokta
if [ -f "/Users/nicholas.jones/.okta/okta-aws" ]; then
    . "/Users/nicholas.jones/.okta/okta-aws"
fi

# Load zshrc helpers from textnow
if [ -d ~/.zshrc.d ]; then
  for i in ~/.zshrc.d/*; do
    source $i
  done
fi


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ll='ls -Al'
#[[ -s "$HOME/.rvm/scripts/rvm" ]] || gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && curl -sSL https://get.rvm.io | bash -s stable
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
alias vss='vagrant ssh'
export PATH="/opt/puppetlabs/puppet/bin:$PATH"
export PATH="$HOME/.rvm/rubies/ruby-2.4.1/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
alias nj='ssh -l nojones'
#alias uwd='export MY_WD=$(pwd);sed --in-place --follow-symlinks "/^export MY_WD/d" ~/.zshrc'
alias uwd='export MY_WD=$(pwd);sed -i.bak "/^export MY_WD/d" $(readlink ~/.zshrc);echo "export MY_WD=$(pwd)" >> ~/.zshrc'
alias pa='${MY_WD}/pa'
alias wd='cd ${MY_WD}'
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"


autoload -U +X bashcompinit && bashcompinit
if command -v terraform &> /dev/null
then
complete -o nospace -C terraform terraform
fi
if command -v kubectl &> /dev/null
then
  source <(kubectl completion zsh)
  alias k=kubectl
  complete -F __start_kubectl k
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/nojones/src/nojones/configs/bin/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/nojones/src/nojones/configs/bin/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/nojones/src/nojones/configs/bin/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/nojones/src/nojones/configs/bin/google-cloud-sdk/completion.zsh.inc'; fi


NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"  # This loads nvm
source "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
if command -v kube_ps1 &> /dev/null
then
  export PS1='$(kube_ps1) %{$purple%}%n${PR_RST} at %{$orange%}%m${PR_RST} in %{$limegreen%}%~${PR_RST} $vcs_info_msg_0_$(virtualenv_info)
# '
else
  export PS1='%{$purple%}%n${PR_RST} at %{$orange%}%m${PR_RST} in %{$limegreen%}%~${PR_RST} $vcs_info_msg_0_$(virtualenv_info)
# '
fi


#Withokta
if [ -f "/Users/nicholas.jones/.okta/okta-aws" ]; then
    . "/Users/nicholas.jones/.okta/okta-aws"
fi

export PATH="$HOME/Library/Python/3.9/bin:$PATH"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
export PATH="$HOME/.rvm/gems/ruby-2.5.1/bin:$HOME/.rvm/bin:$PATH"
export MY_WD=/Users/nicholas.jones/src/textnow/kubernetes/_build-scripts/Diff
export GPG_TTY=$(tty)
