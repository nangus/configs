#alias ypu='cd ~/src/yp-engineering/yp'
if [[ `echo $-|grep i`  ]]
      then
      exec zsh --login
fi
#
