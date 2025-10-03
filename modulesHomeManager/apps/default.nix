{ lib, config, ... }:
{
  imports = [
    ./nextcloud.nix
    ./kitty.nix
  ];

  options = {
    apps.enable = lib.mkEnableOption "enable apps bundle";
  };

  config = lib.mkIf config.apps.enable {
    nextcloud.enable = true;
    kitty.enable = true;
  };
}
