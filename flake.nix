{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    stylix.url = "github:danth/stylix";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    zen-browser.url = "gitlab:InvraNet/zen-flake";
    nixcord.url = "github:kaylorben/nixcord";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs-stable, nixpkgs, home-manager, plasma-manager
    , hyprpanel, spicetify-nix, nixcord, stylix, ... }:
    let
      system = "x86_64-linux";

      overlays = [ inputs.hyprpanel.overlay ];

      unstable = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };
      stable = import nixpkgs-stable {
        inherit system overlays;
        config.allowUnfree = true;
      };
      pkgs = unstable;
      config = (builtins.fromTOML (builtins.readFile ./config.toml));
      user = config.user;
      development = config.development;
    in {
      nixosConfigurations.${user.username} = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          (import ./config/configuration.nix user config.system config.desktop)
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              sharedModules = [
                plasma-manager.homeManagerModules.plasma-manager
                inputs.nixcord.homeModules.nixcord
              ];
              users.${user.username} = ./home/home.nix;
              extraSpecialArgs = {
                inherit pkgs development user unstable stable system inputs;
                username = user.username;
              };
            };
          }
          stylix.nixosModules.stylix
        ];
      };
      formatter.${system} = pkgs.nixfmt-classic;
    };
}
