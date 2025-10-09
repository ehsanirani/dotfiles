{ config, pkgs, lib, eemacs ? null, pkgs-unstable, ... }:

{
  # Import modular configuration
  imports = [
    ./modules/terminal-shell.nix
    ./modules/editors.nix
    ./modules/development.nix
    ./modules/git.nix
    ./modules/internet.nix
    ./modules/multimedia.nix
    ./modules/fonts.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Home Manager basics
  home.username = "ehsan";
  home.homeDirectory = "/home/ehsan";
  home.stateVersion = "25.05";

  # Standalone home-manager CLI
  home.packages = with pkgs; [
    home-manager   # standalone CLI for fast user rebuilds
  ];
}
