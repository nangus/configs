#!/bin/bash
TMPN=$RANDOM
curl -s 'http://www.reddit.com/r/wallpapers' | tr '"' '\n' | grep imgur | tee "$TMPN.tmp" | egrep '^http://i\.imgur\.com/' | xargs wget -q -nc

