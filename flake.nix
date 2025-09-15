{
  description = "Ehsan’s system + user config (NixOS 25.05)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }: let
    system = "x86_64-linux";
  in {
    homeConfigurations.ehsan = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};   # <-- add this
      inherit system;
      modules = [ ./home/ehsan.nix ];
    };

    nixosConfigurations.laptop-dell = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./hosts/laptop-dell.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ehsan = import ./home/ehsan.nix;
        }
      ];
    };
  };
}

