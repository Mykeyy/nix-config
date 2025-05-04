# InvraNet's NixOS Flake

My main operating system is NixOS, which means this flake will be updated often.
This system is meant to be partially modular to allow for configuration and installation for your user.

## Example
This section shows what the flake will look like.
<br><br>
<details open>
<summary>Spotify + Ghostty + Waybar</summary>
![Demo 1](./.res/demo_1.png)
</details>

<details>
<summary>Development Envrionment</summary>
![Demo 2](./.res/demo_2.png)
</details>

<details>
<summary>Neovim with Mako</summary>
![Demo 3](./.res/demo_3.png)
</details>


## Configuration
Inside of the root of this directory, you have your `config.toml`, which specifies how
`home/home.nix`, `flake.nix`, etc handle and configure certain pieces of the system.
Most of these settings pertain to your user account, networking, system services,
graphics, and window management.

Your `config.toml` looks like this from the start:

```toml
[user]
username = "invranet"
displayName = "InvraNet"
initialPassword = "123456"

[system]
greeter = "gdm"
hostname = "NixOS"
timezone = "Australia/Sydney"
locale = "en_AU.UTF-8"
kernelParams = [
  "intel_iommu=on",
  "iommu=pt",
  "vfio-pci.ids=10de:2182,10de:1aeb,10de:1aec,10de:1aed",
]

[system.networking]
networkmanager = false
dhcpEnabled = false

[[system.networking.interfaces]]
type = "BRIDGE"
name = "br0"
interfaces = ["enp7s0"]
dhcpEnabled = true


[system.graphics]
blacklists = ["nouveau", "nvidia"]
wanted = ["amdgpu"]


[[system.graphics.processor]]
type = "AMD"
name = "Radeon RX 6700 XT"
driver = "amdgpu"

[[system.graphics.processor]]
type = "NVDIA"
name = "GeForce GTX 1660 Ti"
driver = "nvidia"

[system.services]
ssh.enable = true
mongodb.enable = true

[desktop]
[desktop.hyprland]
enable = true
wallpapers = [
  "/home/invranet/.wallpapers/Catalina Coast.png",
]

[[desktop.hyprland.monitors]]
name = "DP-2"
resolution = "2560x1440"
refreshRate = 180
position = "0x0"
scale = 1

[[desktop.hyprland.monitors]]
name = "DP-3"
resolution = "1920x1080"
refreshRate = 180
position = "2560x0"
scale = 1

[development]
[development.git]
username = "InvraNet"
types = ["GitLab", "GitHub"]
email = "identificationsucks@gmail.com"
defaultBranch = "main"
```


## `[user]` section
This section contains user-related settings.

- `username`: Specifies the username to be used for home-manager and the user to be created.
- `displayName`: Specifies the display name used in the `description` field for user settings in `config/configuration.nix`.
- `initialPassword`: Only used if the flake is applied during the installation of NixOS or as a built ISO. This sets the user's initial password. **Do not use your actual password** here; instead, change it afterward using `passwd`.

---

## `[system]` section
Configures system-wide settings.

- `greeter`: The display manager which is used when logged out.
- `hostname`: The system's hostname, used in the network and shell (e.g., `[username]@[hostname]`).
- `timezone`: Specifies the system's timezone. You can find your timezone using `timedatectl list-timezones`.
- `locale`: Sets the system's default locale (e.g., `en_AU.UTF-8`).
- `kernelParams`: A list of kernel parameters applied at boot.

### [system.networking] section
Configures networking settings.
- `networkmanager`: Boolean to which if you want NetworkManager enabled.
- `dhcpEnabled`: Boolean to which if you want network wide DHCP enabled.

#### [[system.networking.interfaces]] (Multiple entries allowed)
- `type`: Type of connection currently there's ONLY `BRIDGE`.
- `name`: Name of new generated interface.
- `interfaces`: List of interfaces to be slaves.
- `dhcpEnabled`: Boolean to which if you want DHCP Enabled to this interfaces.


### `[system.graphics]` section
Configures GPU settings.

- `blacklists`: A list of kernel modules to blacklist (e.g., `nouveau`, `nvidia`).
- `wanted`: Specifies the preferred graphics drivers (e.g., `amdgpu`).

#### `[[system.graphics.processor]]` (Multiple entries allowed) **Currently functionless, but will be used in the future, so pleese configure accordingly...**
Configures individual graphics processors.

- `type`: Specifies the GPU vendor (e.g., `AMD`, `NVIDIA`).
- `name`: Specifies the GPU model.
- `driver`: Specifies the graphics driver to use.

### `[system.services]` section
Controls system services.

- `ssh.enable`: Enables SSH access if set to `true`.
- `mongodb.enable`: Enables MongoDB if set to `true`.

---

## `[desktop]` section
Configures desktop environment settings.

### `[desktop.hyprland]` section
Configures Hyprland settings.

- `enable`: Enables Hyprland if set to `true`.
- `wallpapers`: A list of monitor-specific wallpapers in the format `"<monitor_name>, <path_to_wallpaper>"`.

#### `[[desktop.hyprland.monitors]]` (Multiple entries allowed)
Defines monitor configurations.

- `name`: The monitor's identifier (e.g., `DP-2`).
- `resolution`: The monitor's resolution (e.g., `2560x1440`).
- `refreshRate`: The monitor's refresh rate in Hz.
- `position`: The monitor's position (e.g., `2560x0`).
- `scale`: The display scaling factor.

---

## `[development]` section
Configures development tools.

### `[development.git]` section
Configures Git settings.

- `username`: Default Git username for commits.
- `types`: List of what your git username appears on (eg. GitHub.)
- `email`: Default Git email for commits.
- `defaultBranch`: Default branch to use when running `git init`.

---

This configuration file provides a modular and flexible way to manage your NixOS system, ensuring user settings, system services, desktop environments, and development tools are consistently applied. Modify `config.toml` as needed to match your preferences.
