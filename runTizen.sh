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
BACKUP_DIR="$SCRIPT_ROOT/_backups"

# ==============
# Dates config
# ==============

DATE_FORMAT='%Y-%m-%d__%H-%M'
DATE=(`date +$DATE_FORMAT`)

# ==============
# Set CMD
# ==============

case $1 in
    "xterm" | "debug" | "d" )
        # xterm is useful for debugging
        CMD='xterm'
        ACTION="false"
        ;;
    "backup" | "purge" )
        # general actions
        CMD="false"
        ACTION=$1
        ;;
    * )
        # Default: Tizen Studio
        CMD="/opt/scripts/runTizenIDE.sh"
        ACTION="false"
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

    if [[ $CMD != "false" ]]; then
        # allow root (and the docker) connection to X-Server
        xhost +local:root
    fi
}

terminate() {
    printText "Terminating ..."

    if [[ $CMD != "false" ]]; then
        # disallow root connection to X-Server
        xhost -local:root
    fi

    exit
}

askContinue() {
    read -p $'\n Continue? [Y/n] ' ans
    echo ""
    if [[ $ans != 'Y' ]]; then
        printText "Aborted by user"
        terminate
    fi
}

# docker volumes purge process
interactivePurge() {
    cd "$SCRIPT_ROOT"
    source "$ENV_FILE"

    printText "Interactive volumes purge started..."

    printText "About to clear LOCAL_TIZEN_STUDIO_DIRECTORY: \n$LOCAL_TIZEN_STUDIO_DIRECTORY"
    read -p "Clear it? [Y/N] " ans
    if [[ $ans == 'Y' ]]; then
        rm -rf "$LOCAL_TIZEN_STUDIO_DIRECTORY"
        mkdir "$LOCAL_TIZEN_STUDIO_DIRECTORY"
        echo "... OK"
    else
        echo "... clearing skipped."
    fi

    printText "About to clear LOCAL_TIZEN_STUDIO_DATA_DIRECTORY: \n$LOCAL_TIZEN_STUDIO_DATA_DIRECTORY"
    read -p "Clear it? [Y/N] " ans
    if [[ $ans == 'Y' ]]; then
        rm -rf "$LOCAL_TIZEN_STUDIO_DATA_DIRECTORY"
        mkdir "$LOCAL_TIZEN_STUDIO_DATA_DIRECTORY"
        echo "... OK"
    else
        echo "... clearing skipped."
    fi

    printText "About to clear LOCAL_WORKSPACE: \n$LOCAL_WORKSPACE"
    echo -e "\033[33mNOTE: \033[33;5mTHIS WILL CLEAR YOUR PROJECT WORKSPACE\033[0m"
    echo -e "\033[33m      (you can say 'no' if all you want is to restart the IDE installation process)\033[0m"
    read -p "Clear it? [Y/N] " ans
    if [[ $ans == 'Y' ]]; then
        rm -rf "$LOCAL_WORKSPACE"
        mkdir "$LOCAL_WORKSPACE"
        echo "... OK"
    else
        echo "... clearing skipped."
    fi

    printText "Interactive volumes purge finished..."
}

# volume data backup process
volumesBackup() {
    CURRENT_BACKUP_DIR="$BACKUP_DIR"/"$DATE"

    cd "$SCRIPT_ROOT"
    source "$ENV_FILE"

    # user confirmation
    printText "Notice:\nDocker volumes backups will be saved at: \n$CURRENT_BACKUP_DIR"
    askContinue

    # actual backup
    mkdir -p "$CURRENT_BACKUP_DIR"
    cp -ap "$LOCAL_TIZEN_STUDIO_DIRECTORY" "$CURRENT_BACKUP_DIR"
    cp -ap "$LOCAL_TIZEN_STUDIO_DATA_DIRECTORY" "$CURRENT_BACKUP_DIR"
    cp -ap "$LOCAL_WORKSPACE" "$CURRENT_BACKUP_DIR"

    printText "Backup is done. To restore the backup data, please manually copy it into the defined volume paths."
}

main() {
    init

    if [[ $CMD != "false" ]]; then
        # default - run the container
        $authPrefix docker compose \
            --file "$COMPOSE_FILE" \
            --env-file "$ENV_FILE" \
            run --rm tizen "$CMD"

    elif [[ $ACTION == "backup" ]]; then
        # backup docker volumes
        volumesBackup

    elif [[ $ACTION == "purge" ]]; then
        # clear docker volumes
        interactivePurge
    fi

    terminate
}

# ==================
# Invoke the script
# ==================

autoSetAuthPrefix
set -eu
main
