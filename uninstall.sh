#!/bin/sh

DIR=$(dirname $(readlink -f $0))
cd $DIR

set -eu
# set -x

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

nixuninstall pass password-store
nixuninstall qtpass

nixuninstall emacs
nixuninstall parcellite
nixuninstall compton
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
nixuninstall zile
nixuninstall mr
nixuninstall stow
nixuninstall gnupg
nixuninstall keybase nodejs-keybase
nixuninstall git
nixuninstall git-crypt

if ! is_nixos; then
    rm -I -rf $HOME/.nix-profile $HOME/.nix-channels
fi

hash -r
