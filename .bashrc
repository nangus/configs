#alias ypu='cd ~/src/yp-engineering/yp'
if [[ `echo $-|grep i`  ]]
      then
      exec zsh --login
echo pfft
fi
#

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
