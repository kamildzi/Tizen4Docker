#!/usr/bin/env bash
# @K.Dziuba
# Tizen IDE docker start script
# NOTE: you need to run "build.sh" before running this script

# say 'yes' if you want to use sudo for docker. 
useSudo='yes'

# Set CMD
case $1 in
    "xterm" | "debug" | "d" )
        # xterm is useful for debugging
        CMD='xterm'
        ;;
    * )
        # Default: Tizen Studio
        CMD="/opt/scripts/runTizenIDE.sh"
        ;;
esac

# ==============
# Functions
# ==============

setRunPrefix() {
    # Sudo support
    if [[ $useSudo == 'yes' ]]; then
        runPrefix='sudo'
    else
        runPrefix=''
    fi
}

init() {
    echo " [$0] Starting up ..."

    # traps
    trap terminate SIGINT SIGTERM ERR

    # allow root (and the docker) connection to X-Server
    xhost +local:root
    TERMINATED=0
}

terminate() {
    if [[ $TERMINATED == 0 ]]; then
        echo " [$0] Terminating ..."

        # disallow root connection to X-Server
        xhost -local:root
        TERMINATED=1
    fi
}

main() {
    init

    # run the container 
    $runPrefix docker-compose run --rm tizen $CMD

    terminate
}

# ==============
# EO: Functions
# ==============

setRunPrefix
set -eu
main
