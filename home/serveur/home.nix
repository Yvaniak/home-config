{ lib, ... }:
{
  imports = [ ../../modulesHomeManager ];
  home-common.enable = true;
  #desactivate pass et gpg sur le serveur
  pass.enable = lib.mkForce false;
  gpg.enable = lib.mkForce false;

  home.username = lib.mkForce "serveur";
  home.homeDirectory = lib.mkForce "/home/serveur";

  cli-apps.enable = lib.mkForce false;
  zsh.enable = true;
}
