{ stdenv, pkgs, mkScript }:

with pkgs;
mkScript {
  name = "sc";
  src = ./sc;
  postBuild = ''
    substituteInPlace $scriptBin \
      --replace slop ${slop}/bin/slop \
      --replace import ${imagemagick}/bin/import \
  '';
}
