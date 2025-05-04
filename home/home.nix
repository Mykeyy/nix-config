{ development, user, pkgs, inputs, system, ... }:

{
  imports = [
    ./system/programs.nix
    ./spicetify.nix
    ./system/fastfetch.nix
    ./system/stylixTargets.nix
    ./system/hyprland.nix
    ./system/plasma.nix
    ./file.nix
  ];

  home = {
    username = user.username;
    homeDirectory = "/home/" + user.username;
    stateVersion = "24.11";
    sessionVariables = {
      EDITOR = "nvim";
      GIT_EDITOR = "nvim";
    };
  };
}
