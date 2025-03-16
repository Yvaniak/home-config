{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cosmic-manager = {
      url = "github:HeitorAugustoLN/cosmic-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    mydevenvs.url = "github:yvaniak/mydevenvs";
    mydevenvs.inputs.nixpkgs.follows = "nixpkgs";

    #packages only
    nix-search = {
      url = "github:diamondburned/nix-search";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:nix-community/nixGL/310f8e49a149e4c9ea52f1adf70cdc768ec53f8a";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    filesort = {
      url = "github:yvaniak/filesort";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #fin perso
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } rec {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      imports = [
        inputs.mydevenvs.flakeModule
        inputs.mydevenvs.devenv
      ];

      perSystem =
        {
          pkgs,
          config,
          lib,
          ...
        }:

        let
          configNvf = {
            options = { };
            config = import ./packages/nvf.nix { inherit pkgs; };
          };

          customNeovim = inputs.nvf.lib.neovimConfiguration {
            inherit pkgs;
            modules = [ configNvf ];
          };
        in
        {
          packages = {
            myNvim = customNeovim.neovim;
            auto-updater = pkgs.callPackage ./packages/auto-updater { };
            status-projets-viewer =
              (import ./packages/status-projets-viewer).outputs.packages.x86_64-linux.default;
          };

          devenv.shells.default = {
            mydevenvs = {
              nix = {
                enable = true;
                flake.enable = true;
              };
              c.enable = true;
              tools.just = {
                enable = true;
                pre-commit.enable = true;
                check.enable = true;
              };
            };
            enterShell = "echo hello from home-config";
          };

          checks =
            {
              inherit (config.packages) auto-updater;
              inherit (config.packages) status-projets-viewer;
            }
            // lib.mkIf (builtins.getEnv "HOMECONFIG_CHECKS_RESTRICT" != "1") {

              ewen-home = flake.homeConfigurations.ewen.activation-script;
              examens-home = flake.homeConfigurations.examens.activation-script;
              serveur-home = flake.homeConfigurations.serveur.activation-script;
            };
        };

      flake =
        let
          overlay = _final: _prev: {
            nix-search = inputs.nix-search.packages.${pkgs.system}.default;
            filesort = inputs.filesort.packages.${pkgs.system}.default;
          };
          system = "x86_64-linux";
          pkgs = import inputs.nixpkgs {
            inherit system;

            config = {
              allowUnfree = true;
              permittedInsecurePackages = [
                "dotnet-sdk-6.0.428"
              ];
            };

            overlays = [ overlay ];
          };

          configNvf = {
            options = { };
            config = import ./packages/nvf.nix { inherit pkgs; };
          };

          customNeovim = inputs.nvf.lib.neovimConfiguration {
            inherit pkgs;
            modules = [ configNvf ];
          };
        in
        {
          homeConfigurations = {
            ewen = inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = {
                inherit inputs;
                inherit (pkgs) system;
                inherit customNeovim;
              };

              modules = [ ./home/ewen/home.nix ];

              # Optionally use extraSpecialArgs
              # to pass through arguments to home.nix
            };

            examens = inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = {
                inherit inputs;
                inherit (pkgs) system;
              };

              modules = [ ./home/examens/home.nix ];
            };

            serveur = inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = { inherit inputs; };

              modules = [ ./home/serveur/home.nix ];
            };
          };
        };
    };
}
