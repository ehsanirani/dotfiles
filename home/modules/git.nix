{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Ehsan Irani";
        email = "ehsan.irani@protonmail.com";
      };
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };
}
