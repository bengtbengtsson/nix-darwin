{
  description = "MBA M2 Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager }:
  let
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
          pkgs.alacritty
          pkgs.cmatrix
          pkgs.docker
          pkgs.fossil
          pkgs.fzf
          pkgs.git
          pkgs.gnupg
          pkgs.google-chrome
          pkgs.htop
          pkgs.logisim-evolution
          pkgs.mkalias
          pkgs.nushell
          pkgs.neofetch
          pkgs.obsidian
          pkgs.postman
          pkgs.ripgrep
          pkgs.teams
          pkgs.thonny
          pkgs.tmux
          pkgs.tree
          pkgs.watchman
          pkgs.wget
          pkgs.zoom-us
        ];

        fonts.packages = [
          (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
        ];

        homebrew = {
          enable = true;
          taps = [
#            "mongodb/brew"
          ];
          brews = [
            "mas"
          ];
          casks = [
            "brave-browser"
            "the-unarchiver"
            "vlc"
          ];
          onActivation.cleanup = "zap";
          onActivation.autoUpdate = true;
          onActivation.upgrade = true;
          masApps = {
            Utm = 1538878817;
          };
        };

        system.activationScripts.enableRosetta = ''
          /usr/sbin/softwareupdate --install-rosetta --agree-to-license
        '';

        system.activationScripts.applications.text = let
          env = pkgs.buildEnv {
            name = "system-applications";
            paths = config.environment.systemPackages;
            pathsToLink = "/Applications";
          };
        in
        pkgs.lib.mkForce ''
          # Set up applications.
          echo "setting up /Applications..." >&2
          rm -rf /Applications/Nix\ Apps
          mkdir -p /Applications/Nix\ Apps
          find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read -r src; do
            app_name=$(basename "$src")
            echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          done
        '';

        system.defaults = {
          dock.autohide = true;
          dock.persistent-apps = [
            "${pkgs.alacritty}/Applications/Alacritty.app"
            "${pkgs.obsidian}/Applications/Obsidian.app"
            "${pkgs.google-chrome}/Applications/Google Chrome.app"
            "/System/Applications/Utilities/Terminal.app"
          ];
          finder.FXPreferredViewStyle = "clmv";
          loginwindow.GuestEnabled = false;
          NSGlobalDomain.AppleICUForce24HourTime = true;
          NSGlobalDomain.AppleInterfaceStyle = "Dark";
          trackpad.Clicking = true;
          trackpad.FirstClickThreshold = 0;
          trackpad.TrackpadRightClick = true;
        };


      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # allow touchID in terminal
      security.pam.enableSudoTouchIdAuth = true;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };

    homeconfig = {pkgs, ...}: {
      # this is internal compatibility configuration 
      # for home-manager, don't change this!
      home.stateVersion = "23.05";
      # Let home-manager install and manage itself.
      programs.home-manager.enable = true;

      home.packages = with pkgs; [];

      home.sessionVariables = {
        EDITOR = "vim";
      };

      programs.git = {
        enable = true;
        userName = "Bengt Bengtsson";
        userEmail = "bengt.bengtsson@gmail.com";
        aliases = {
          st = "status";
          co = "checkout";
          br = "branch";
          ci = "commit";
        };
      };

    };
      in
      {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."MBAM2" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "ben";
            autoMigrate = true;
          };
        }
        home-manager.darwinModules.home-manager  {
          users.users.ben.home = "/Users/ben";
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.users.ben = homeconfig;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."MBAM2".pkgs;
  };
}
