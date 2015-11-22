#!/bin/sh

DIR=$(dirname $(readlink -f $0))
cd $DIR

set -eu
# set -x

hash -r

. ${DIR}/common.sh

if [ -d ~/.password-store ]; then
    if [ -n "$(git -C ~/.password-store status --porcelain)" ]; then
        echo "Password store is not clear, exiting!"
        exit
    fi
    rr rm -rf ~/.password-store
fi;

rrunstow stack
rrunstow emacs
rrunstow xinit
rrunstow awesome
rrunstow xmodmap
rrunstow parcellite
rrunstow compton
rrunstow themes
rrunstow zile
rrunstow git
rrunstow zsh
rrunstow bin
rrunstow myrepos

if enabled crypto; then
    nixuninstall git-crypt
    nixuninstall gpg2 gnupg
    nixuninstall keybase nodejs-keybase
    nixuninstall pass password-store
    nixuninstall qtpass
fi

if enabled haskell; then
    nixuninstall stack
    nixuninstall hasktags
    nixuninstall hindent
    nixuninstall stylish-haskell
    nixuninstall structured-haskell-mode
    nixuninstall hlint
    nixuninstall ghc-mod
    nixuninstall cabal cabal-install
    nixuninstall ghc
    nixuninstall ag silver-searcher
fi

nixuninstall emacs
nixuninstall parcellite
nixuninstall compton

nixuninstall zile
nixuninstall mr
nixuninstall stow
nixuninstall git

if ! is_nixos; then
    rm -I -rf $HOME/.nix-profile $HOME/.nix-channels
fi

REMAINING_LINKS=$(find -type l -printf "%p -> %l\n" | grep "\-> dotfiles")

if [ -n "$REMAINING_LINKS" ]; then
    echo "$REMAINING_LINKS are still linked to dotfiles/"
    exit 1
fi

hash -r

echo ">>> Uninstallation finished successfully!"
