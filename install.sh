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

mkdir -p $HOME/.ssh 
touch $HOME/.ssh/authorized_keys

(
    echo "\n# Further keys are taken from github.com/gleber.keys on $(datetime)"
    curl https://github.com/gleber.keys
) >> $HOME/.ssh/authorized_keys

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

if exists awesome; then
    nixinstall compton
    rrstow compton
    rrstow xmodmap
    rrstow awesome
    rrstow xinit
    nixinstall parcellite
    rrstow parcellite
fi

missing emacs
nixinstall emacs
rrstow emacs

hash -r
