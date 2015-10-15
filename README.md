# Dotfiles

This is gleber's dotfiles. It is roughly based on xero's repo. It tries to
provide both semi-permanent configuration and semi-permanent application
versions. It supplies `install.sh` script, which sets up most apps and
configs using Nix, Stow and myrepos.

## Installation

```sh
git clone https://github.com/gleber/dotfiles.git $HOME/dotfiles
$HOME/dotfiles/install.sh
```

Installer assumes the following:

* either Ubuntu or NixOs
* Posix-compatible shell
* installed git, zsh and curl

## Included configs and apps

Currently it installs configuration for:

* awesome
* compton
* myrepos (to manage dotfile dependencies)
* zsh
* git
* zile
* xmodmap (maps CapsLock to Control)
* emacs (Spacemacs)

It installs nix as user-level package manager if `nix-env` is not found.

It installs the following binaries from Nixpkgs:

* stow
* mr
* zile
* ag
* ghc
* compton
* emacs

## Properties

By depending on nixpkgs, it can keep at bay versions of most-used utilities even
if system package manager updates something. Currently it uses `master` of
`nixpkgs`, hence it will install whatever version of a binary is defined there.
In future it is planned to pin commit id of `nixpkgs` to ensure stable binaries
versions.

It uses Spacemacs, which brings in a lot of packages from all kinds of *ELPAs,
so versions there are also not predictable.

If you want to see a hardcore approach to version stability of one's
environment, please check out https://github.com/nilcons/ceh
