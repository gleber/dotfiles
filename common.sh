#!/bin/sh

set -eu
# set -x

DRY=${DRY:-""}

if ! [ "$DIR" = "$HOME/dotfiles" ]; then
    echo "dotfiles repo should be in $HOME/dotfiles"
    exit 1
fi

rr() {
    if [ -n "$DRY" ]; then
        echo ">>> Skipping $*"
        return 0
    fi
    echo ">>> Running $*"
    eval "$@"
}

hash -r

exists() {
    hash $1 2>/dev/null
}

nixexists() {
    if exists $1; then
        which $1 | grep -q "$HOME/.nix-profile/"
        return $?
    fi
    return 1
}

require() {
    hash -r
    if ! exists "$1"; then
        echo "!!! $1 is required, but could not be found!"
        exit 1
    else
        echo ">>> $1 is present as expected"
    fi
}

missing() {
    hash -r
    if nixexists "$1"; then
        echo "!!! $1 should not be present in ~/.nix-profile, but it is!"
        exit 1
    else
        echo ">>> $1 is missing as expected"
    fi
}

APTGET=
if exists apt-get; then
    APTGET=$(which apt-get)
fi
NIXENV=
if exists nix-env; then
    NIXENV=$(which nix-env)
fi

NIXOS=
if [ -f /etc/nixos/configuration.nix ]; then
    NIXOS=true
fi

is_nixos() {
    [ "$NIXOS" = "true" ];
}

nixuninstall() {
    bin=$1
    pkg=${2:-$1}
    nixop uninstall "$bin" "$pkg"
}

nixop() {
    op=$1
    bin=$2
    pkg=${3:-$bin}
    hash -r
    if [ "$op" = "install" ]; then
        if nixexists "$bin"; then
            echo ">>> Skipping installation of $bin (package $pkg)"
            return 0
        fi
        rr $NIXENV -f '\<nixpkgs\>' -i -A "$pkg"
        require "$bin"
    elif [ "$op" = "uninstall" ]; then
        if ! exists "$bin"; then
            echo ">>> Skipping uninstallation of $bin (package $pkg)"
            return 0
        fi
        rr $NIXENV -f '\<nixpkgs\>' -e "$pkg"
        missing "$bin"
    else
        exit 3
    fi
}

nixinstall() {
    bin=$1
    pkg=${2:-$1}
    nixop install "$bin" "$pkg"
}

rrunstow() {
    if [ -n "$DRY" ]; then
        stow -n -D -vv "$@"
    else
        stow -vv -D "$@"
    fi
}

rrstow() {
    if [ -n "$DRY" ]; then
        stow -n -vv "$@"
    else
        stow -vv "$@"
    fi
}

