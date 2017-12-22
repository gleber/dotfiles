{ pkgs, ... }:
let
  lib = pkgs.callPackage ./lib.nix {};
  callPackage = pkgs.newScope lib;
  wrapBin = lib.wrapBin;
in
{
  pretty_config     = wrapBin ../../../bin/bin/pretty_config.erl;
  gitio             = wrapBin ../../../bin/bin/gitio;
  imgur             = wrapBin ../../../bin/bin/imgur;
  ix                = wrapBin ../../../bin/bin/ix;
  kerl              = wrapBin ../../../bin/bin/kerl;
  nix-search        = wrapBin ../../../bin/bin/nix-search;
  screencast-window = wrapBin ../../../bin/bin/screencast-window;
  tmx               = wrapBin ../../../bin/bin/tmx;
  inotifyrun        = callPackage ../../../bin/inotifyrun {};
  sc                = callPackage ../../../bin/sc {};
}
