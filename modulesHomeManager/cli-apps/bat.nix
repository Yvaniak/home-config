{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    bat.enable = lib.mkEnableOption "enable bat module";
  };

  config = lib.mkIf config.bat.enable {
    programs.bat = {
      enable = true;
      config = {
        theme = "catppuccin";
      };
      themes = {
        catppuccin = {
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat"; # Bat uses sublime syntax for its themes
            rev = "6810349b28055dce54076712fc05fc68da4b8ec0";
            sha256 = "sha256-lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";
          };
          file = "themes/Catppuccin\ Mocha.tmTheme";
        };
      };
      extraPackages = [
        pkgs.bat-extras.prettybat
        pkgs.bat-extras.batdiff
        pkgs.bat-extras.batman
        pkgs.bat-extras.batgrep
        pkgs.bat-extras.batwatch
      ];
    };
  };
}
