#!/bin/bash

function msroot {
    if [[ $1 == "-h" ]] || [[ $1 == "--help" ]]
    then
        echo "msroot: change the current working directory to the root folder of the microservice"
        return
    fi
    
    reposPath=~/Repositories/

    if [[ $PWD == $reposPath* ]]
    then
        pathInRepo=${PWD/$reposPath/}
        repoName=${pathInRepo%%/*}
        repoRootPath=$reposPath$repoName
        
        cd $repoRootPath
    else
        echo ">> ERROR: You are currently not in a microservice folder under ~/Repositories"
    fi
}