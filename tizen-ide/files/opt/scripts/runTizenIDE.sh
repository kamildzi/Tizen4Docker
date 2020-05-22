#!/usr/bin/env bash
# @K.Dziuba
# Tizen IDE install and start script wrapper (installation should be invoked only when it's needed)

# gnome-keyring support: link keyring data
VOLUME_DATA_DIR=~/tizen-studio-data/_EXT_TIZEN4DOCKER_/.local
if [[ ! -d $VOLUME_DATA_DIR ]]; then
    mkdir --parents $VOLUME_DATA_DIR
fi

rm -rf ~/.local
ln -s $VOLUME_DATA_DIR ~/.local

# init dbus, run the IDE
dbus-run-session -- bash -c '\
    echo 12345 | gnome-keyring-daemon --unlock \
    \
    /opt/scripts/installTizenIDE.sh && \
    ~/tizen-studio/ide/TizenStudio.sh'
