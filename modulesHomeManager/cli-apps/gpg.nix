{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    gpg.enable = lib.mkEnableOption "enable gpg module";
  };

  config = lib.mkIf config.pass.enable {
    programs.gpg.enable = true;
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry;
      maxCacheTtl = 300;
    };
  };
}
