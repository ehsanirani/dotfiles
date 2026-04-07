{ config, pkgs, lib, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    firefox
    google-chrome
    chromium
    telegram-desktop
    pkgs-unstable.thunderbird
    zoom-us
    zulip
    slack
    pkgs-unstable.openconnect
  ];
}
