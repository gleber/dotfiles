{ pkgs, ... }:
let
  bs = name: baseNameOf (toString name);
  wrapBin = fn: pkgs.writeScriptBin (bs fn) (builtins.readFile fn);
in
{
  gitio             = wrapBin ../../../bin/bin/gitio;
  imgur             = wrapBin ../../../bin/bin/imgur;
  inotifyrun        = wrapBin ../../../bin/bin/inotifyrun;
  ix                = wrapBin ../../../bin/bin/ix;
  kerl              = wrapBin ../../../bin/bin/kerl;
  nix-search        = wrapBin ../../../bin/bin/nix-search;
  screencast-window = wrapBin ../../../bin/bin/screencast-window;
  tmx               = wrapBin ../../../bin/bin/tmx;
}
