#!/bin/bash

function irm {
    if [[ $1 == "-h" ]] || [[ $1 == "--help" ]]
    then
        echo "irm: install and run a microservice if the current working directory is somewhere under the project's folder"
        return
    fi
    
    reposPath=~/Repositories/

    if [[ $PWD == $reposPath* ]]
    then
        pathInRepo=${PWD/$reposPath/}
        repoName=${pathInRepo%%/*}
        repoRootPath=$reposPath$repoName
        
        cd $repoRootPath
        mvn-install-run
    else
        echo ">> ERROR: You are currently not in a project folder under ~/Repositories"
    fi
}