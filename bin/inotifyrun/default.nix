{ stdenv, pkgs, mkScript }:

with pkgs;
mkScript {
  name = "inotifyrun";
  src = ./inotifyrun;
  postBuild = ''
    substituteInPlace $scriptBin \
      --replace inotifywait ${inotify-tools}/bin/inotifywait
  '';
}
