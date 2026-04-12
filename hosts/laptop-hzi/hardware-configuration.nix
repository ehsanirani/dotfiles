# Placeholder — replace on laptop-hzi with output of `nixos-generate-config`.
{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  # Intentionally empty. Real values generated on the target machine.
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
