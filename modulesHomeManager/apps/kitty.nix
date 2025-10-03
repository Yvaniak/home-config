{
  lib,
  config,
  ...
}:
{
  options = {
    kitty.enable = lib.mkEnableOption "enable kitty module";
  };

  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;
      settings = {
        cursor_trail = 3;
      };
      enableGitIntegration = true;
      shellIntegration.enableZshIntegration = true;
    };
  };
}
