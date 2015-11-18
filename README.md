# Dotfiles

[![Build Status](https://travis-ci.org/gleber/dotfiles.svg?branch=master)](https://travis-ci.org/gleber/dotfiles)

This is gleber's dotfiles. It tries to provide both semi-permanent configuration
and semi-permanent application versions. It supplies `install.sh` script, which
sets up most apps and configs using Nix, Stow and myrepos. This config makes use
of gpg encryption to store some sensitive information in the public github. For
more details read `private/README.md`.

It was originally inspired by xero's dotfiles.

## Installation

```sh
git clone https://github.com/gleber/dotfiles.git $HOME/dotfiles
$HOME/dotfiles/install.sh
```

Installer assumes the following:

* either Ubuntu or NixOs
* Posix-compatible shell
* installed zsh, curl, ssh and bzcat

## Testing

Local test can be run with Docker:

```sh
make build
make test
```

This will build an ubuntu image, clone newest dotfiles repo in it and try to run
install and uninstall scripts (with private stuff replaced with anonymized
versions).

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

If you want to see a hardcore approach to version stability of user
environment, please check out https://github.com/nilcons/ceh
