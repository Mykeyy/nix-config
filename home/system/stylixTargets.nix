{ pkgs, ... }:
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    image = ./config/.wallpapers/purpleglaze.png;
    targets = {
      btop.enable = false;
      starship.enable = false;
      spicetify.enable = false;
      qt.enable = false;
      hyprland.enable = false;
      zed.enable = false;
      vscode.enable = false;
      vencord.enable = false;
      vesktop.enable = false;
      nixcord.enable = false;
    };
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono Nerd Font";
      };
    };
  };
}
