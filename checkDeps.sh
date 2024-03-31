#!/usr/bin/env bash
# @K.Dziuba
# Tizen4Docker dependencies check

REQUIREMENTS="docker xhost bash"

# Define colors (ANSI)
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[1;33m'
C_NOCOLOR='\033[0m'

# Print wrapper
# $1 - color
# $2, $3, ... - message text 
printText() {
    CLR=$1
    shift
    while (( "$#" )); do
        printf "${CLR}$1${C_NOCOLOR}"
        shift
    done
}

# Dynamic tab length
tabLen=8
for req in $REQUIREMENTS; do
    newLen=$( expr length $req )
    newLen=$(( newLen + 4 ))

    if (( $tabLen < $newLen )); then
        tabLen=$newLen
    fi
done
tabs $tabLen

# Failed marker
_failed=0

# Dependency check
printText $C_NOCOLOR "Checking: \n"
for req in $REQUIREMENTS; do
    printText $C_NOCOLOR "  $req \t"
    which $req &> /dev/null

    if [[ $? != 0 ]]; then
        printText $C_RED "... Failed"
        _failed=1
    else
        printText $C_GREEN "... OK"
    fi
    printf "\n"
done

if [[ $_failed != 0 ]]; then
    printText $C_YELLOW "\nMissing dependencies detected." \
            "\nUse your package manager to install the software.\n\n"
    exit 100
else
    printText $C_GREEN "\nAll fine.\n\n"
fi
