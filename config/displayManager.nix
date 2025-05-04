system: {
  services.xserver.displayManager.gdm = {
    enable = system.greeter == "gdm";
    wayland = true;
  };
}
