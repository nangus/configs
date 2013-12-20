#!/bin/bash
for i in `ls --color='never' -A |grep -v .git|grep -v setup.sh`
do
	ln -s `pwd|sed s#$HOME#~#`/$i ~/$i
done
