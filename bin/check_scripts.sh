#!/usr/bin/zsh
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
            if [ `ls $PAT/NODE_VERSION 2>/dev/null` ]; then
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
        needV=`correct_node`
        echo $needV
        if [[ $needV != '' ]]; then
            if [[ $nodeV == $needV ]]; then
                echo "| %{$fg[green]%} $nodeV %{$reset_color%} " 2>/dev/null
            else
                echo "| %{$fg[red]%} $nodeV %{$reset_color%} " 2>/dev/null
            fi
        fi
    fi
}
node_version
