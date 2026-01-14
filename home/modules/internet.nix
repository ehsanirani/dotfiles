{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    firefox
    google-chrome
    chromium
    telegram-desktop
    zulip
    slack
  ];
}
