{ pkgs, inputs, system, ... }:
let spicePkgs = inputs.spicetify-nix.legacyPackages.${system};
in {
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.sleek;
    colorScheme = "RosePine";

    enabledExtensions = with spicePkgs.extensions; [
      powerBar
      beautifulLyrics
      volumePercentage
      ({
        src = pkgs.fetchFromGitHub {
          owner = "notPlancha";
          repo = "volume-profiles-v2";
          rev = "490c20f1b12672a9eddc6aedd09ad161f14a4a97";
          sha256 = "gbG/OnIPR/okeYgN8RDn9gwbQVISdnbdQe1fqfgkc6o=";
        };
        name = "dist/volume-profiles.js";
      })
    ];
  };
}
