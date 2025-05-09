{ pkgs, ... }:

let
  # Read and parse the TOML configuration file
  tomlConfig = builtins.fromTOML (builtins.readFile ../../config.toml);

  # Extract Plasma configuration
  enable = tomlConfig.desktop.plasma.enable;
in
{
  programs.plasma = {
    inherit enable;

    workspace = {
      clickItemTo = "select";
      lookAndFeel = "stylix";
      enableMiddleClickPaste = false;
    };

    hotkeys.commands."launch-ghostty" = {
      key = "Meta+Return";
      name = "Launch Ghostty";
      command = "ghostty";
      comment = "Launch Ghostty terminal.";
    };

    panels = [
      {
        location = "top";
        hiding = "autohide";
        floating = true;

        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];

    shortcuts = {
      ksmserver = {
        "Lock Session" = [
          "Screensaver"
          "Meta+L"
        ];
      };

      navigation = {
        "Quit" = "Meta+Q";
      };

      kwin = {
        "Switch Window Down" = "Meta+J";
        "Switch Window Left" = "Meta+H";
        "Switch Window Right" = "Meta+L";
        "Switch Window Up" = "Meta+K";

        "Switch to Desktop 1" = "Meta+1";
        "Switch to Desktop 2" = "Meta+2";
        "Switch to Desktop 3" = "Meta+3";
        "Switch to Desktop 4" = "Meta+4";
        "Switch to Desktop 5" = "Meta+5";
        "Switch to Desktop 6" = "Meta+6";
        "Switch to Desktop 7" = "Meta+7";
        "Switch to Desktop 8" = "Meta+8";
        "Switch to Desktop 9" = "Meta+9";

        "Window to Desktop 1" = "Meta+!";
        "Window to Desktop 2" = "Meta+@";
        "Window to Desktop 3" = "Meta+#";
        "Window to Desktop 4" = "Meta+$";
        "Window to Desktop 5" = "Meta+%";
        "Window to Desktop 6" = "Meta+^";
        "Window to Desktop 7" = "Meta+&";
        "Window to Desktop 8" = "Meta+*";
        "Window to Desktop 9" = "Meta+(";
      };
    };

    configFile = {
      "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
      "kwinrc"."org.kde.kdecoration2"."ButtonsOnLeft" = "SF";
      "kwinrc"."Desktops" = {
        "Rows" = 3;
        "Number" = {
          value = 9;
          immutable = true;
        };
      };
    };
  };
}
