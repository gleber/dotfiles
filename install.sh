#!/bin/sh

DIR=$(dirname $(readlink -f $0))
cd $DIR

set -eu
# set -x

. ${DIR}/common.sh

require git
require zsh
require curl

if ! exists nix-env; then
    curl https://nixos.org/nix/install | sh
fi

case "$PATH" in
    *nix-profile*)
        ;;
    *)
        . ~/.nix-profile/etc/profile.d/nix.sh
        ;;
esac

NIXENV=$(which nix-env)

nixinstall stow
nixinstall mr
rrstow myrepos

mr checkout

hash -r

rrstow zsh
rrstow git

nixinstall zile
rrstow zile

rrstow themes

nixinstall ag silver-searcher
nixinstall ghc haskellPackages.ghc
nixinstall cabal haskellPackages.cabal-install
nixinstall ghc-mod haskellPackages.ghc-mod
nixinstall hlint haskellPackages.hlint
nixinstall structured-haskell-mode haskellPackages.structured-haskell-mode
nixinstall stylish-haskell haskellPackages.stylish-haskell
nixinstall hindent haskellPackages.hindent
nixinstall hasktags haskellPackages.hasktags
nixinstall stack

nixinstall compton
rrstow compton

if exists awesome; then
    rrstow xmodmap
    rrstow awesome
    rrstow xinit
fi

nixinstall emacs
rrstow emacs
