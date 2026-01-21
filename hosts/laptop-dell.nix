{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "${pkgs.mongodb-ce.pname}-${pkgs.mongodb-ce.version}"
  ];
  
  #######################################################################
  # 1.  SSH host keys (same fingerprint after every reinstall)
  #######################################################################
  services.openssh = {
    enable = true;
    hostKeys = [
      { path = "/etc/ssh/ssh_host_ed25519_key"; type = "ed25519"; }
      { path = "/etc/ssh/ssh_host_rsa_key";     type = "rsa";     bits = 4096; }
    ];
  };

  #######################################################################
  # 2.  Authorised user public key
  #######################################################################
  users.users.ehsan.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICxqxVL5tXvciZRJEU16w4mDjPw8AOWNWssaCivqW+7r ehsan@laptop-dell"
  ];

  #######################################################################
  # 3.  Decrypt private key into ~/.ssh at activation  <-- NEW BLOCK
  #######################################################################
  age.secrets.id_ed25519 = {
    file = ../secrets/id_ed25519.age;          # encrypted file in repo
    path = "/home/ehsan/.ssh/id_ed25519";      # where to place plain text
    owner = "ehsan";
    group = "users";
    mode  = "0600";
  };

  # API keys
  age.secrets.deepseek-api-key = {
    file = ../secrets/deepseek-api-key.age;
    path = "/home/ehsan/.config/secrets/deepseek-api-key";
    owner = "ehsan";
    group = "users";
    mode = "0400";
  };

  age.secrets.kimi-api-key = {
    file = ../secrets/kimi-api-key.age;
    path = "/home/ehsan/.config/secrets/kimi-api-key";
    owner = "ehsan";
    group = "users";
    mode = "0400";
  };

  age.secrets.moonshot-api-key = {
    file = ../secrets/moonshot-api-key.age;
    path = "/home/ehsan/.config/secrets/moonshot-api-key";
    owner = "ehsan";
    group = "users";
    mode = "0400";
  };

  # Use host key instead of user key to avoid circular dependency during rebuild
  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  #age.identity = builtins.readFile ../secrets/id_ed25519.age;   # encrypted, safe to store

  #######################################################################
  # 4.  ssh-agent auto-started on graphical login
  #######################################################################
  programs.ssh.startAgent = true;

  # … rest of your existing config …
  
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

  # COSMIC Desktop (alternative option at login)
  services.desktopManager.cosmic.enable = false;

  # Audio (PipeWire)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # MongoDB
  services.mongodb = {
    enable = true;
    package = pkgs.mongodb-ce;
  };
  
  # Shell
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = false;
  programs.fish.enable = true;
  # Users
  users.users.ehsan = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    shell = pkgs.fish;
  };

  # Security
  security.sudo.wheelNeedsPassword = false;

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Enable nix-ld for running dynamically linked executables (needed for juliaup)
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    gcc.cc.lib   # libstdc++
    glibc        # libc
    zlib
    bzip2
    xz
    stdenv.cc.cc.lib  # ensures some compilers' runtime
    openssl
  ];

  # System-wide packages
  environment.systemPackages = with pkgs; [
    git wget curl gnugrep gnutar gzip
  ];

  # Enable native Wayland support for Electron/Chromium apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # NEVER change after install
  system.stateVersion = "25.05";
}

