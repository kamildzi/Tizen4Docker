#!/usr/bin/env bash
# @K.Dziuba
# Tizen IDE installer

# Tizen install directory
TIZEN_DIR=~/tizen-studio/

# make sure we're at correct location
SCRIPT_ROOT=$( readlink -f $( dirname "${BASH_SOURCE[0]}" ) )
cd $SCRIPT_ROOT;

# ==============
# Functions
# ==============

# Fail and exit
# $1 - fail message
fail(){
    echo -e " [$0;ERR] $1\n"
    exit 100
}

# fetch and setup the IDE
fetchTizen(){
    # download the IDE
    cd ~                                 || fail "Failed to switch to home-dir"
    wget ${TIZEN_REPO}"/"${TIZEN_BINARY} || fail "Failed to get Tizen from: \n${TIZEN_REPO}"/"${TIZEN_BINARY}"
    chmod +x ./${TIZEN_BINARY}

    # install the IDE
    ./${TIZEN_BINARY} --accept-license "$TIZEN_DIR"                                               || fail "Install step 1 failed"
    ./tizen-studio/package-manager/package-manager-cli.bin install NativeIDE Emulator PlatformIDE || fail "Install step 2 failed"
    ./tizen-studio/package-manager/package-manager-cli.bin install ${TIZEN_TARGET}                || fail "Install step 3 failed"

    # cleaning
    rm ~/${TIZEN_BINARY}
    TIZEN_INSTALLED=1
}

# sets $TIZEN_INSTALLED variable to 1 or 0
# NOTE: assume that installation is required only when $TIZEN_DIR is empty
checkInstallState(){
    if find "$TIZEN_DIR" -mindepth 1 | read; then
        # dir not empty
        TIZEN_INSTALLED=1
    else
        # dir empty
        TIZEN_INSTALLED=0
    fi
}

main(){
    checkInstallState
    if [[ $TIZEN_INSTALLED == 0 ]]; then
        # start the installation process
        fetchTizen

        # re-check status
        if [[ $TIZEN_INSTALLED == 0 ]]; then
            fail "Failed to install the Tizen Studio!"
        else
            echo "Tizen Studio installed successfully!"
        fi
    else
        # tizen ide is installed
        echo "Tizen Studio is already installed."
    fi
}

# ==============
# EO: Functions
# ==============

set -u
source ./imgConfig.sh || fail "Failed to source image config!"
main
exit 0
