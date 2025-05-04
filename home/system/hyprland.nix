{ config, pkgs, lib, ... }:

let
  # Read and parse the TOML configuration file
  tomlConfig = builtins.fromTOML (builtins.readFile ../../config.toml);

  # Extract Hyprland configuration
  hyprland = tomlConfig.desktop.hyprland;

  # Parse the monitors from the TOML file into a Nix-compatible format
  monitors = builtins.map (monitor: {
    name = monitor.name;
    resolution = monitor.resolution;
    refreshRate = monitor.refreshRate;
    position = monitor.position;
    scale = monitor.scale;
  }) hyprland.monitors;
in {
  imports = [ ./hyprpanel.nix ];

  wayland.windowManager.hyprland = {
    enable = hyprland.enable;

    settings = {
      monitor = builtins.map (monitor:
        "${monitor.name},${monitor.resolution}@${
          builtins.toString monitor.refreshRate
        },${monitor.position},${builtins.toString monitor.scale}") monitors;

      # Auto-launching
      exec-once = [ "swww-daemon &" "hyprpanel" ];

      # General settings
      general = {
        gaps_in = 2;
        gaps_out = 5;
        "col.active_border" = "rgb(7800e3) rgb(c452e0) 45deg";
        "col.inactive_border" = "rgba(00000000)";
      };

      decoration = {
        rounding = 15;
        blur = {
          enabled = true;
          size = 10;
          passes = 2;
          noise = 0.1;
        };
      };

      animations = { enabled = true; };

      # Inputs (keyboard & mouse)
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0.5;
        touchpad = { natural_scroll = true; };
      };

      render = { explicit_sync = false; };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Keybinds
      bind = [
        "SUPER, Return, exec, ghostty"
        "SUPER, S, exec, spotify"
        "SUPER, Z, exec, zeditor"
        "SUPER, D, exec, vesktop"
        "SUPER, T, exec, thunar"
        "SUPER, Space, exec, rofi -show drun"
        "SUPER, V, exec, clipman pick -t rofi"
        "SUPER, B, exec, zen"
        "SUPER, Q, killactive"
        "SUPER ALT SHIFT, Q, exit"
        "ALT LSHIFT, F10, exec, playerctl previous"
        "ALT LSHIFT, F11, exec, playerctl play-pause"
        "ALT LSHIFT, F12, exec, playerctl next"
        "SUPER LSHIFT, S, exec, nu ~/.config/hypr/scripts/screenshot.nu"
        "SUPER LSHIFT, Space, togglefloating"
        "SUPER, C, togglesplit"
        "ALT, Return, fullscreen"
        "SUPER, 1, workspace, 1"
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER SHIFT, 5, movetoworkspace, 5"
      ];

      # Mouse bindings
      bindm =
        [ "SUPER, mouse:272, movewindow" "SUPER, mouse:273, resizewindow" ];

      windowrulev2 = [
        "pin, title:Picture-in-Picture"
        "float, title:Picture-in-Picture"
        "size 640 360, title:Picture-in-Picture"
        "pin, title:Picture-in-Picture"
      ];
    };
  };
  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
