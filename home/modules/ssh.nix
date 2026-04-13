{ config, pkgs, lib, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "brics" = {
        hostname = "brws046.br-simm.nat.tu-bs.de";
        user = "eir26";
        identityFile = "~/.ssh/brics_id";
        identitiesOnly = true;
      };
      "brws*" = {
        hostname = "%h.br-simm.nat.tu-bs.de";
        user = "eir26";
        identityFile = "~/.ssh/brics_id";
        identitiesOnly = true;
      };
    };
  };
}
