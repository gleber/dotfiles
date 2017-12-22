{ stdenv, pkgs, bash, coreutils}:

rec {
  /**
    pathBaseName gets a basename (aka filename) of a path passed to it.
  */
  pathBaseName = name: baseNameOf (toString name);

  /**
    wrapBin takes a path to a shell script and packages it into a package with the same name.
  */
  wrapBin = fn: pkgs.writeScriptBin (pathBaseName fn) (builtins.readFile fn);

  /**
    mkScript provides a way to quickly nixify existing bash scripts.
  */
  mkScript = { name, src, postBuild ? "", binName ? name, pathPackages ? [], ... }: derivation {
    inherit name src stdenv binName;
    builder = pkgs.writeScript "${name}-builder" ''
      #!${bash}/bin/bash
      export PATH=${ stdenv.lib.makeBinPath ([ coreutils ] ++ pathPackages) }
      source $stdenv/setup
      mkdir -p $out/bin
      export scriptBin="$out/bin/${binName}"
      cp $src $scriptBin
      patchShebangs $out/bin
      ${postBuild}
    '';
    system = builtins.currentSystem;
  };
}
