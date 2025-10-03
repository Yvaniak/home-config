{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    kitty.enable = lib.mkEnableOption "enable kitty module";
  };

  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;
      package = config.lib.nixGL.wrap pkgs.kitty;
      settings = {
        cursor_trail = 3;
      };
      enableGitIntegration = true;
      shellIntegration.enableZshIntegration = true;
    };
  };
}
