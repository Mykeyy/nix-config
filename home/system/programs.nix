{
  development,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    # Developer Tools
    python312
    nodejs
    lazygit
    lua
    # postman
    lm_sensors
    cargo
    ghostty
    pandoc
    pgadmin4-desktopmode
    mongodb-compass

    # Language Servers & Plugins
    marksman
    markdownlint-cli2
    lua-language-server
    bash-language-server
    tailwindcss-language-server
    nushellPlugins.polars
    kde-rounded-corners
    luarocks
    nil

    # Multimedia Tools
    viu
    vlc
    wayvnc
    ffmpeg
    fzf
    libsForQt5.kdenlive

    # System Libraries & Utilities
    wl-clipboard
    file
    tree
    libnotify
    pavucontrol
    killall
    xclicker

    # School Tools
    teams-for-linux

    # CLI Utilities
    yt-dlp
    wineWowPackages.stable
    superfile
    fanctl
    qpwgraph
    # coolercontrol.coolercontrol-gui

    # Games
    lutris-unwrapped
    bottles
    scrcpy
    # resilio-sync

    # Day-to-Day Applications
    zen
    # osu-lazer
    easyeffects
    davinci-resolve
    kdePackages.kcolorpicker
    chromium
    localsend
    # parsec-bin
    obsidian
    flatpak
    prismlauncher

    #gamemodder
    r2modman
  ];

  programs = {
    home-manager.enable = true;

    ripgrep.enable = true;

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        droidcam-obs
      ];
    };

    git = {
      enable = true;
      userName = development.git.username;
      userEmail = development.git.email;

      extraConfig = {
        init.defaultBranch = development.git.defaultBranch;
      };
    };

    gh = {
      enable = true;
      settings = {
        editor = "nvim";
      };
    };

    zed-editor = {
      enable = false;
    };

    vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        pkief.material-icon-theme
        bradlc.vscode-tailwindcss
        ms-vsliveshare.vsliveshare
        ms-vscode.live-server
        kamikillerto.vscode-colorize
        bierner.github-markdown-preview
        mvllow.rose-pine
        leonardssh.vscord
        jnoortheen.nix-ide
      ];
    };

    neovim = {
      enable = true;
    };

    nushell = {
      enable = true;
      configFile.source = ./config/config.nu;
    };

    starship = {
      enable = true;
      enableNushellIntegration = true;
    };

    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      options = [ "--cmd cd" ];
    };

    btop = {
      enable = true;
      package = pkgs.btop-rocm;
    };

    nixcord = {
      enable = true;
      discord.enable = false;
      vesktop.enable = true;
      quickCss = builtins.readFile ./config/vesktop/main.css;
      config = {
        useQuickCss = true;
        themeLinks = [ ];
        frameless = true;
        plugins = {
          experiments.enable = true;
          betterSettings.enable = true;
          callTimer.enable = true;
          crashHandler.enable = true;
          fixSpotifyEmbeds = {
            enable = true;
            volume = 9.0;
          };
          fixYoutubeEmbeds.enable = true;
          imageZoom.enable = true;
          noF1.enable = true;
          onePingPerDM.enable = true;
          openInApp.enable = true;
          quickReply.enable = true;
          spotifyControls.enable = true;
          spotifyCrack.enable = true;
          spotifyShareCommands.enable = true;
          voiceChatDoubleClick.enable = true;
          voiceDownload.enable = true;
          voiceMessages.enable = true;
          volumeBooster = {
            enable = true;
            multiplier = 5;
          };
          webKeybinds.enable = true;
          webRichPresence.enable = true;
          webScreenShareFixes.enable = true;
          youtubeAdblock.enable = true;
        };
      };
    };
  };
}
