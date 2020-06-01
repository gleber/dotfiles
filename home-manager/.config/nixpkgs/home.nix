{ pkgs, ... }:

let
  mybinpkgs = import ./binpkgs.nix { pkgs = pkgs; };
in
{
  imports = [
    ./private.nix
  ];

  home.packages = with pkgs; [
    htop gksu
    chromium rxvt_unicode
    slop imagemagick pgadmin
    xss-lock
    inotify-tools
    direnv
    pass
    tree
    jq
    keybase-gui
    # xkill

    steam

    gitAndTools.git-crypt
    gitAndTools.hub
    gitAndTools.git-hub
    git-lfs
    mr
    silver-searcher
    ripgrep
    ncdu
    acpi
    file
    unzip

    ccls

    unetbootin
    gparted
    ntfs3g
    ms-sys
  ] ++ (builtins.attrValues mybinpkgs);

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
	  userEmail = "gleber.p@gmail.com";
	  userName = "Gleb Peregud";
    aliases = {
      graph = ''log --graph --color --pretty=format:"%C(yellow)%H%C(green)%d%C(reset)%n%x20%cd%n%x20%cn%x20(%ce)%n%x20%s%n"'';
      stat = "status -sb";
      last = "log -1 --stat";
      unstage = "reset HEAD --";
      restore = "reset --hard HEAD";
      sync = "pull --rebase";
      cached = "diff --cached";
    };

    extraConfig = ''
      [color]
        ui = auto
      [rerere]
        enabled = true
      [push]
        default = simple
      [credential]
        helper = cache
      [pull]
        rebase = true
    '';
  };

  programs.browserpass = {
    enable = true;
    browsers = [ "firefox" "chromium" ];
  };

  programs.firefox = {
    enable = true;
    # enableAdobeFlash = true;
    enableIcedTea = true;
  };

  programs.emacs = {
    enable = true;
    # extraPackages = epkgs: [
    #   epkgs.nix-mode
    #   epkgs.magit
    # ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    initExtra = ''
      # Source Prezto.
      if [[ -s "''${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
        source "''${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
      fi

      eval "$(direnv hook zsh)"
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.ssh = {
    enable = true;
    forwardAgent = true;
    matchBlocks = {
      "*" = {
        serverAliveInterval = 60;
      };
    };
  };

  services.parcellite.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
    enableExtraSocket = true;
  };

  services.picom = {
    enable = true;
  };

  services.redshift = {
    enable = true;
    provider = "geoclue2";
  };

  services.keybase.enable = true;
  services.kbfs = {
    enable = true;
    mountPoint = "kbfs";
  };

  services.unclutter.enable = true;
  services.udiskie.enable = true;

  systemd.user.startServices = true;

  programs.home-manager = {
    enable = true;
    path = "/home/gleber/.config/nixpkgs/home-manager";
    # path = https://github.com/rycee/home-manager/archive/master.tar.gz;
  };
}
