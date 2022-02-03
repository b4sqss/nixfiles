{
  description = "My system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nur = {
    #   url = "github:nix-community/NUR";
    # };

    #emacs-overlay = {
    #url = "github:nix-community/emacs-overlay";
    #inputs.nixpkgs.follows = "nixpkgs";
    #};

  };

  outputs = { nixpkgs, home-manager, ... }: 
    let 
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true;};
      };

      lib = nixpkgs.lib;

    in {
      homeManagerConfigurations = {
        basqs = home-manager.lib.homeManagerConfiguration {
          inherit system pkgs;
          username = "basqs";
          homeDirectory = "/home/basqs";
          stateVersion = "21.11";
          configuration = {
            imports = [ ./users/home.nix ];
          };
        };
      };

      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;

          modules = [ ./system/configuration.nix ];
        };
      };
    };
}
