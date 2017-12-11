{ stdenv, pkgs }:

with pkgs;
derivation {
  name = "inotifyrun";
  src = ./inotifyrun;
  stdenv = stdenv;
  builder = pkgs.writeScript "inotifyrun-builder" ''
    #!${bash}/bin/bash
    export PATH=${ lib.makeBinPath [ coreutils ] };
    source $stdenv/setup
    mkdir -p $out/bin
    cp $src $out/bin/inotifyrun
    patchShebangs $out/bin
    substituteInPlace $out/bin/inotifyrun --replace inotifywait ${inotify-tools}/bin/inotifywait
  '';
  system = builtins.currentSystem;
}
