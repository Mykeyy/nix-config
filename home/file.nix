{ ... }:
{
  home.file = {
    ".config/starship.toml" = {
      source = ./system/config/starship.toml;
    };
    ".config/nvim" = {
      source = ./system/config/neovim;
      recursive = true;
    };
    ".config/waybar" = {
      source = ./system/config/waybar;
      recursive = true;
    };
    ".config/mako" = {
      source = ./system/config/mako;
      recursive = true;
    };
    ".config/btop/btop.conf" = {
      source = ./system/config/btop/btop.conf;
    };
    ".config/ghostty" = {
      source = ./system/config/ghostty;
      recursive = true;
    };
    ".config/fastfetch/nixos.png" = {
      source = ./system/config/fastfetch/nixos.png;
    };
    ".config/Code/User/settings.json" = {
      source = ./system/config/vscode/settings.json;
    };
    ".config/zed/settings.json" = {
      source = ./system/config/zed/settings.json;
    };
    ".config/hyprpanel" = {
      source = ./system/config/hyprpanel;
      recursive = true;
    };
  };
}
