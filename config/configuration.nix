user: system: desktop:
{ nixpkgs, pkgs, config, ... }: {
  imports = [
    ./stylix.nix
    (import ./displayManager.nix system)
    ./hardware-configuration.nix
  ];
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://nix-community.cachix.org" ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  time.timeZone = system.timezone;

  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;
      qemu.ovmf.enable = true;
    };
    spiceUSBRedirection.enable = true;
    vmVariant.virtualisation = {
      memorySize = 8192;
      cores = 8;
      diskSize = 128 * 1024;
    };
  };

  hardware.nvidia = {
    open = true;
    nvidiaSettings = true;
    modesetting.enable = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "575.51.02";
      sha256_64bit = "sha256-XZ0N8ISmoAC8p28DrGHk/YN1rJsInJ2dZNL8O+Tuaa0=";
      sha256_aarch64 = "sha256-NNeQU9sPfH1sq3d5RUq1MWT6+7mTo1SpVfzabYSVMVI=";
      openSha256 = "sha256-NQg+QDm9Gt+5bapbUO96UFsPnz1hG1dtEwT/g/vKHkw=";
      settingsSha256 = "sha256-6n9mVkEL39wJj5FB1HBml7TTJhNAhS/j5hqpNGFQE4w=";
      persistencedSha256 = "sha256-dgmco+clEIY8bedxHC4wp+fH5JavTzyI1BI8BxoeJJI=";
    };

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  };


  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_6_12;
    kernelParams = system.kernelParams;
    kernelModules = [ "v4l2loopback" ];
    blacklistedKernelModules = system.graphics.blacklists;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  security = {
    doas = {
      extraRules = [{
        groups = [ "wheel" ];

        keepEnv = true;
        persist = true;
      }];
      enable = true;
    };
    polkit.enable = true;
  };

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    xserver = {

      enable = true;
      videoDrivers = system.graphics.wanted;
      xkb = {
        layout = "us";
        options = "eurosign:e,caps:escape";
      };
    };

    desktopManager.plasma6.enable = desktop.plasma.enable;

    fwupd.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    libinput.enable = true;
    openssh.enable = true;
    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          securityType = "user";
          "workgroup" = "IDALON";
          "server string" = "Main SMB";
          "netbios name" = "smbnix";
          "security" = "user";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "private" = {
          "path" = "/srv/smb";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "invranet";
          "force group" = "wheel";
        };
      };
    };
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    elisa
    dolphin
  ];

  hardware = { graphics.enable = true; };

  networking = {
    hostName = system.hostname;
    networkmanager.enable = system.networking.networkmanager;
    firewall.enable = system.networking.firewallEnabled;
    };
  i18n.defaultLocale = system.locale;
  environment.stub-ld.enable = true;

  programs = {
    hyprland.enable = true;
    nix-ld.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    virt-manager.enable = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  users.users.${user.username} = {
    isNormalUser = true;
    initialPassword = user.initialPassword;
    description = user.displayName;
    shell = pkgs.nushell;
    extraGroups = [ "networkmanager" "docker" "wheel" "libvirtd" ];
    packages = with pkgs; [
      wayvnc
      wget
      jdk21
      glib
      libreoffice-qt-fresh
      remmina
      gcc
      clang-tools
      cmake
      calibre
      gnumake
    ];
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      font-awesome
      corefonts
      vistafonts
      noto-fonts
      noto-fonts-emoji
    ];
    fontconfig.defaultFonts.monospace = [ "JetBrainsMono" ];
  };

  system.stateVersion = "24.11";
}
