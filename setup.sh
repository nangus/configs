#!/bin/bash
for i in `ls -A |grep -v '^.gitconfig'|grep -v '^.git$' |grep -v setup.sh`
do
    if [[ -h ~/$i ]]; then
        rm ~/$i
    fi
    if [[ -e ~/$i ]]; then
        echo "~/$i exists and can not be created "
    else
        ln -s `pwd`/$i ~/$i
    fi
done

if [[ -h ~/.gitconfig ]]; then 
    rm ~/.gitconfig
fi
if [[ -e ~/.gitconfig ]]; then 
    echo "~/.gitconfig exists and can not be created "
else
    if [[ $(which git) ]]; then
        if [[ $(git --version|grep 1.8) ]]; then
            ln -s `pwd`/.gitconfig.1.8 ~/.gitconfig
        else
            ln -s `pwd`/.gitconfig.1.7 ~/.gitconfig
        fi
    else
        echo "git is not installed we are not going to create a simlink to ~/.gitconfig"
    fi
fi
