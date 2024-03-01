{ agenix, config, pkgs, ... }:

let
  user = "probablyadev";
in
{
  imports = [
    ../../modules/darwin/secrets.nix
    ../../modules/darwin/home-manager.nix
    ../../modules/shared
    ../../modules/shared/cachix
    agenix.darwinModules.default
  ];

  # Setup user, packages, programs
  nix = {
    gc = {
      user = "root";
      automatic = true;
      interval = { Weekday = 0; Hour = 1; Minute = 0; };
      options = "--delete-older-than 7d";
    };

    package = pkgs.nixUnstable;

    settings = {
      auto-allocate-uids = true;
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = [
        "auto-allocate-uids"
        "dynamic-derivations"
        "flakes"
        "nix-command"
        "recursive-nix"
      ];
      keep-build-log = false;
      max-jobs = "auto";
      trusted-users = [ "@admin" "${user}" ];
      use-xdg-base-directories = true;
    };
  };

  # Load configuration that is shared across systems
  environment.systemPackages = with pkgs; [
    agenix.packages."${pkgs.system}".default
  ] ++ (import ../../modules/shared/packages.nix { inherit pkgs; });

  # Enable fonts dir
  fonts = {
    fonts = with pkgs; [
      fira-code
      fira-code-symbols
    ];

    fontDir.enable = true;
  };

  # launchd.user.agents.emacs.path = [ config.environment.systemPath ];
  # launchd.user.agents.emacs.serviceConfig = {
  #   KeepAlive = true;
  #   ProgramArguments = [
  #     "/bin/sh"
  #     "-c"
  #     "/bin/wait4path ${pkgs.emacs}/bin/emacs && exec ${pkgs.emacs}/bin/emacs --fg-daemon"
  #   ];
  #   StandardErrorPath = "/tmp/emacs.err.log";
  #   StandardOutPath = "/tmp/emacs.out.log";
  # };

  programs.nix-index.enable = true;

  security.pam.enableSudoTouchIdAuth = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  system = {
    stateVersion = 4;

    # Turn off NIX_PATH warnings now that we're using flakes
    checks.verifyNixPath = false;

    defaults = {
      alf = {
        allowdownloadsignedenabled = 1;
        globalstate = 1;
        stealthenabled = 1;
      };

      CustomSystemPreferences = {
        "com.apple.appleseed.FeedbackAssistant" = {
          "Autogather" = false;
        };

        "com.apple.dt.Xcode" = {
          "ShowBuildOperationDuration" = true;
        };

        "com.apple.Safari" = {
          "CloseTabsAutomatically" = 3;
          "DownloadsClearingPolicy" = 2;
          "EnableEnhancedPrivacyInRegularBrowsing" = 1;
          "HomePage" = "https://app.daily.dev/";
          "IncludeDevelopMenu" = 1;
          "SearchProviderShortName" = "DuckDuckGo";
        };
      };

      CustomUserPreferences = {
        "com.apple.dock" = {
          "expose-group-apps" = true;
          "scroll-to-open" = true;
        };

        "com.apple.finder" = {
          "FXRemoveOldTrashItems" = true;
        };

        "com.apple.screencapture" = {
          "show-thumbnail" = false;
        };

        # https://learn.microsoft.com/en-au/sharepoint/deploy-and-configure-on-macos
        "com.microsoft.OneDrive" = {
          "AutomaticUploadBandwidthPercentage" = 99;
          "DisableTutorial" = true;
          "EnableSyncAdminReports" = 0;
          "HideDockIcon" = true;
          "KFMBlockOptIn" = 2;
        };
      };

      dock = {
        appswitcher-all-displays = true;
        autohide = true;
        launchanim = true;
        minimize-to-application = true;
        mouse-over-hilite-stack = true;
        mru-spaces = false;
        orientation = "bottom";
        showhidden = true;
        static-only = true;
        tilesize = 16;
        wvous-bl-corner = 1;
        wvous-br-corner = 14;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
      };

      finder = {
        _FXShowPosixPathInTitle = false;
        AppleShowAllFiles = true;
        CreateDesktop = false;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        ShowPathbar = true;
      };

      loginwindow = {
        DisableConsoleAccess = true;
        GuestEnabled = false;
      };

      menuExtraClock = {
        ShowAMPM = false;
        ShowDate = 1;
      };

      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        ApplePressAndHoldEnabled = false;
        AppleShowAllExtensions = true;
        AppleShowScrollBars = "WhenScrolling";

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 2;

        NSDisableAutomaticTermination = false;
        NSTableViewDefaultSizeMode = 1;

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
        "com.apple.keyboard.fnState" = true;
      };

      screencapture = {
        location = "/Users/probablyadev/Pictures";
        type = "png";
      };

      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

      smb = {
        NetBIOSName = "A-Book-Shit-House";
        ServerDescription = "A Book Shit House";
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      # remapCapsLockToControl = true;
    };
  };
}
