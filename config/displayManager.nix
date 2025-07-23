system: {
  services.displayManager.gdm = {
    enable = system.greeter == "gdm";
    wayland = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
}
