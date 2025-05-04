{ development, pkgs, inputs, ... }: {
  home.packages = with pkgs; [
    # Developer Tools
    python312
    nodejs
    lazygit
    lua
    postman
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
    (wrapOBS { plugins = with obs-studio-plugins; [ obs-websocket ]; })
    wayvnc
    ffmpeg
    fzf

    # System Libraries & Utilities
    wl-clipboard
    file
    tree
    waybar
    rofi-wayland
    wofi
    mako
    libnotify
    pavucontrol
    slurp
    grim
    killall
    swww

    # CLI Utilities
    yt-dlp
    wineWowPackages.stable
    superfile
    coolercontrol.coolercontrol-gui

    # Day-to-Day Applications
    inputs.zen-browser.outputs.packages.${pkgs.system}.default
    chromium
    signal-desktop-bin
    parsec-bin
    obsidian
    prismlauncher
  ];

  programs = {
    home-manager.enable = true;

    ripgrep.enable = true;

    git = {
      enable = true;
      userName = development.git.username;
      userEmail = development.git.email;

      extraConfig = { init.defaultBranch = development.git.defaultBranch; };
    };

    gh = {
      enable = true;
      settings = { editor = "nvim"; };
    };

    zed-editor = { enable = true; };

    vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        pkief.material-icon-theme
        bradlc.vscode-tailwindcss
        vscodevim.vim
        ms-vsliveshare.vsliveshare
        ms-vscode.live-server
        kamikillerto.vscode-colorize
        bierner.github-markdown-preview
        mvllow.rose-pine
      ];
    };

    neovim = { enable = true; };

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
