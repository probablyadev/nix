{ config, pkgs, lib, home-manager, ... }:

let
  user = "probablyadev";
  # Define the content of your file as a derivation
  # myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
  #   #!/bin/sh
  #   emacsclient -c -n &
  # '';
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix {};

    caskArgs = {
      appdir = "~/Applications";
      no_quarantine = true;
    };

    global = {
      brewfile = true;
      lockfiles = true;
    };

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    masApps = {
      "Amphetamine" = 937984704;
      "Bitwarden" = 1352778147;
      "Dark Reader for Safari" = 1438243180;
      "GarageBand" = 682658836;
      "Gladys" = 1382386877;
      "Hidden Bar" = 1452453066;
      "iMovie" = 408981434;
      "iStat Menus" = 1319778037;
      "Keynote" = 409183694;
      "Mela" = 1568924476;
      "Messenger" = 1480068668;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "RapidClick" = 419891002;
      "Save to Raindrop.io" = 1549370672;
      "Save to Reader" = 1640236961;
      "Shareful" = 1522267256;
      "SnippetsLab" = 1006087419;
      "SponsorBlock for YouTube - Skip Sponsorships" = 1573461917;
      "Steam Link" = 1246969117;
      "TestFlight" = 899247664;
      "Web Scrobbler" = 6449224218;
      "WhatsApp" = 1147396723;
    };

    onActivation = {
      cleanup = "zap";
      extraFlags = [ "--force" ];
    };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }:{
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};

        file = lib.mkMerge [
          sharedFiles
          additionalFiles
        ];

        stateVersion = "23.11";
      };

      programs = {} // import ../shared/home-manager.nix { inherit config pkgs lib; };
    };
  };

  networking = {
    computerName = "A Book Shit House";
    hostName = "A-Book-Shit-House";
  };
}
