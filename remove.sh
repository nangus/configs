#!/bin/bash
for i in `ls -A |grep -v '^.git$' |grep -v setup.sh`
do
  if [[ -h ~/$i ]]; then
    rm ~/$i
  fi
  if [[ -e ~/$i ]]; then
    echo "~/$i exists should it be removed?"
    read re
    [[ "$(echo $re|head -c 1)" == 'y' ]] && rm -Rf ~/$i
  fi
done
