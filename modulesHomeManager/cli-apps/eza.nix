{
  lib,
  config,
  ...
}:
{
  options = {
    eza.enable = lib.mkEnableOption "enable eza module";
  };

  config = lib.mkIf config.eza.enable {
    programs.eza = {
      enable = true;
      git = true;
      colors = "always";
      icons = "always";
      enableZshIntegration = true;
    };
  };
}
