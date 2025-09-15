{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "laptop-dell";
  networking.networkmanager.enable = true;

  # Locale & time
  time.timeZone = "Europe/Berlin"; # change if needed
  i18n.defaultLocale = "en_US.UTF-8";

  # Desktop
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Audio (PipeWire)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Shell
  programs.zsh.enable = true;
  # Users
  users.users.ehsan = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [ ]; # add your SSH keys here
  };

  # Security
  security.sudo.wheelNeedsPassword = false;

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # System-wide packages
  environment.systemPackages = with pkgs; [
    git wget curl gnugrep gnutar gzip
  ];

  # NEVER change after install
  system.stateVersion = "25.05";
}

