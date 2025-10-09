{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    userName  = "Ehsan Irani";
    userEmail = "ehsan.irani@protonmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };
}
