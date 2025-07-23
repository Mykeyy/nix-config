user: system: desktop:
{
  lib,
  nixpkgs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./stylix.nix
    (import ./displayManager.nix system)
    ./hardware-configuration.nix
  ];
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
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
  
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = system.kernelParams;
    extraModulePackages = with pkgs.linuxPackages_latest; [ v4l2loopback ];
    kernelModules = [ "v4l2loopback" ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Virtual Camera" exclusive_caps=1
    '';
    blacklistedKernelModules = system.graphics.blacklists;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  security = {
    doas = {
      extraRules = [
        {
          groups = [ "wheel" ];

          keepEnv = true;
          persist = true;
        }
      ];
      enable = true;
    };
    polkit.enable = true;
  };

  hardware.nvidia.open = true;

  specialisation = {
    nvidia.configuration = {
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.graphics.enable = true;
      hardware.nvidia.open = true;
      
      hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;
      hardware.nvidia.modesetting.enable = true;


      hardware.nvidia.prime = {
        sync.enable = true;

        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
    };
  };

  services = {
    blueman.enable = true;
    flatpak.enable = true;
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

    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };

    power-profiles-daemon.enable = false;
    tlp.enable = true; # Advanced power management for laptops
    thermald.enable = true; # Thermal management (Intel CPUs)
    upower.enable = true; # Power statistics and battery reporting
    # Optionally, enable acpid for ACPI events (lid, power button, etc.)
    acpid.enable = true;
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    elisa
    dolphin
  ];


  networking = {
    hostName = system.hostname;
    networkmanager.enable = system.networking.networkmanager;
    firewall.enable = system.networking.firewallEnabled;
  };
  i18n.defaultLocale = system.locale;
  environment.stub-ld.enable = true;

  programs = {
    xwayland.enable = lib.mkForce true;
    hyprland.enable = false;
    nix-ld.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    virt-manager.enable = true;
    coolercontrol = {
      enable = true;
      nvidiaSupport = true;
    };
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  users.users.${user.username} = {
    isNormalUser = true;
    initialPassword = user.initialPassword;
    description = user.displayName;
    shell = pkgs.nushell;
    extraGroups = [
      "networkmanager"
      "docker"
      "wheel"
      "libvirtd"
    ];
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

  hardware = {
    enableAllFirmware = true; # Ensures all needed firmware is available
    cpu.intel.updateMicrocode = true; # Enable if you have an Intel CPU
    bluetooth.enable = true;
  };

  environment.systemPackages = with pkgs; [
    tlp
    powertop
    acpi
    kdePackages.kdeconnect-kde
  ];

  system.stateVersion = "24.11";
}
