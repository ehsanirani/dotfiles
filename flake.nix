{
  description = "Ehsan's system + user config (NixOS 25.11)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
    eemacs = {
      url = "github:ehsanirani/eemacs";
      flake = false;
    };
    claude-desktop.url = "github:aaddrick/claude-desktop-debian";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, agenix, eemacs, claude-desktop, ... }: let
    system = "x86_64-linux";
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    # System level, used at boot
    nixosConfigurations.laptop-dell = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit pkgs-unstable; };
      modules = [
        agenix.nixosModules.default
        ./hosts/laptop-dell
        ./modules/printing.nix
        ./modules/flatpak.nix
        ./modules/usb.nix
      ];
    };

    nixosConfigurations.laptop-hzi = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit pkgs-unstable; };
      modules = [
        agenix.nixosModules.default
        ./hosts/laptop-hzi
        ./modules/printing.nix
        ./modules/flatpak.nix
        ./modules/usb.nix
      ];
    };

    # User level, fast rebuilds without sudo
    homeConfigurations = {
      "ehsan@laptop-dell" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ claude-desktop.overlays.default ];
        };
        modules = [ ./home/ehsan.nix ];
        extraSpecialArgs = { inherit eemacs pkgs-unstable; };
      };

      "ehsan@laptop-hzi" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ claude-desktop.overlays.default ];
        };
        modules = [ ./home/ehsan.nix ];
        extraSpecialArgs = { inherit eemacs pkgs-unstable; };
      };

      # Alias for backwards compatibility with `home-manager switch --flake .#ehsan`
      ehsan = self.homeConfigurations."ehsan@laptop-dell";
    };
  };
}
