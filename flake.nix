{
  description = "Ehsan’s system + user config (NixOS 25.05)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
    eemacs = {
      url = "github:ehsanirani/eemacs";
      flake = false;
    };
  };
  
  outputs = { self, nixpkgs, home-manager, agenix, eemacs, ... }: let
    system = "x86_64-linux";
  in {
    # System level, used at boot
    nixosConfigurations.laptop-dell = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        agenix.nixosModules.default
        ./hosts/laptop-dell.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ehsan = import ./home/ehsan.nix;
          home-manager.extraSpecialArgs = { inherit eemacs; };
        }
      ];
    };

    # User level, fast rebuilds without sudo
    homeConfigurations.ehsan = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [ ./home/ehsan.nix ];
      extraSpecialArgs = { inherit eemacs; };
    };
  };
}

