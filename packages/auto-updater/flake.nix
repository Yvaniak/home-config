# This flake was initially generated by fh, the CLI for FlakeHub (version 0.1.10)
{
  # A helpful description of your flake
  description = "An auto-updater so that i do not need to type simple commands";

  # Flake inputs
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  # Flake outputs that other flakes can use
  outputs =
    { self, ... }@inputs:
    let
      # Helpers for producing system-specific outputs
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system: f { pkgs = import inputs.nixpkgs { inherit system; }; }
        );
    in
    {
      packages = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.stdenv.mkDerivation {
            pname = "auto-updater";
            version = "0.1.2.2.1";
            nativeBuildInputs = [
              pkgs.meson
              pkgs.ninja
              pkgs.pkg-config
              pkgs.curlMinimal
              pkgs.jq
            ];
            buildInputs = [
              pkgs.git
              pkgs.nh
              pkgs.curlMinimal
              pkgs.jq
            ];
            src = ./src;
            #meson
            mesonBuildType = "custom";
          };

          auto-updater = self.packages.${pkgs.system}.default;
        }
      );
    };
}
