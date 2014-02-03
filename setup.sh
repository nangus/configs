#!/bin/bash
for i in `ls --color='never' -A |grep -v '^.git$' |grep -v setup.sh`
do
    if [[ -h ~/$i ]]
        then
        rm ~/$i
    fi
    if [[ -e ~/$i ]]
        then
        echo "~/$i exists and can not be created "
    else
        ln -s `pwd`/$i ~/$i
    fi
done
