#!/usr/bin/env bash
# @K.Dziuba
# Tizen4Docker install/startup script

# ===================
# Docker-Auth config
# ===================

# enable for sudo authentication
authWithSudo='yes'

# enable for polkit/pkexec authentication (recommended)
authWithPkexec='yes'

# enable for zensu authentication
# authWithZensu='yes'

# enable for gksu authentication
# authWithGksu='yes'

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# NOTE: to completely disable superuser auth (sudo, pkexec, etc.), 
#       please say 'no' in all above settings (or just comment them out)
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# ==============
# Paths config
# ==============

SCRIPT_ROOT=$( readlink -f $( dirname "${BASH_SOURCE[0]}" ) )
COMPOSE_FILE="$SCRIPT_ROOT/docker-compose.yml"
ENV_FILE="$SCRIPT_ROOT/.env"

# ==============
# Set CMD
# ==============

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

# echo wrapper
# $1 - message to pring
printText() {
    echo -e " [$0] $1"
}

# sets the $authPrefix, if given binary exists
# $1 - binary file
setAuthPrefix() {
    if which "$1" | read; then
        authPrefix="$1"
    else
        printText "$1 not found! Skipping..."
    fi
}

# uses setAuthPrefix() to auto-set the $authPrefix defined in the config
autoSetAuthPrefix() {
    authPrefix=''

    # Sudo support
    if [[ $authWithSudo == 'yes' ]]; then
        setAuthPrefix sudo
    fi

    # Zensu support
    if [[ $authWithZensu == 'yes' ]]; then
        setAuthPrefix zensu
    fi

    # Gksu support
    if [[ $authWithGksu == 'yes' ]]; then
        setAuthPrefix gksu
    fi

    # Polkit/pkexec support
    if [[ $authWithPkexec == 'yes' ]]; then
        setAuthPrefix pkexec
    fi
}

init() {
    printText "Starting up ..."

    # traps
    trap terminate SIGINT SIGTERM ERR

    # allow root (and the docker) connection to X-Server
    xhost +local:root
    TERMINATED=0
}

terminate() {
    if [[ $TERMINATED == 0 ]]; then
        printText "Terminating ..."

        # disallow root connection to X-Server
        xhost -local:root
        TERMINATED=1
    fi
}

main() {
    init

    # run the container 
    $authPrefix docker-compose \
        --file "$COMPOSE_FILE" \
        --env-file "$ENV_FILE" \
        run --rm tizen "$CMD"

    terminate
}

# ==================
# Invoke the script
# ==================

autoSetAuthPrefix
set -eu
main
