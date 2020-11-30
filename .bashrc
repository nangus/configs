#alias ypu='cd ~/src/yp-engineering/yp'
if [[ `echo $-|grep i`  ]]
      then
      exec zsh
fi
#


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/opt/puppetlabs/puppet/bin:$PATH"


# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

complete -C /usr/local/bin/terraform terraform
