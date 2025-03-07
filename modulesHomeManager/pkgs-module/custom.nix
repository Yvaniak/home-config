{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    custom.enable = lib.mkEnableOption "install my packages module";
  };

  config = lib.mkIf config.custom.enable {
    home.packages = [
      pkgs.filesort
      (pkgs.callPackage ./../../packages/auto-updater { })
      (import ../../packages/status-projets-viewer).outputs.packages.x86_64-linux.default
      pkgs.flake-checker
    ];
  };
}
