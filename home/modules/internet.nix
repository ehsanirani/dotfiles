{ config, pkgs, lib, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    firefox
    google-chrome
    chromium
    telegram-desktop
    pkgs-unstable.thunderbird
    zulip
    slack
  ];
}
