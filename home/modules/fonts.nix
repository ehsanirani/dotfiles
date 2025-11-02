{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Nerd Fonts for icons (new syntax for NixOS 25.05)
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    # Robot Slab and Lato fonts
    roboto-slab
    lato
  ];

  # Enable fontconfig for proper font detection
  fonts.fontconfig.enable = true;
}
