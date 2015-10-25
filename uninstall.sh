#!/bin/sh

DIR=$(dirname $(readlink -f $0))
cd $DIR

set -eu
# set -x

. ${DIR}/common.sh

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

rm -I -rf $HOME/.nix-*

hash -r
