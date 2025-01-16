# treefmt.nix
{ ... }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";
  # Enable the rustfmt formatter
  programs = {
    nixpkgs-fmt.enable = true;
    taplo.enable = true;
    clang-format.enable = true;
    meson.enable = true;
  };
  # Override the default package
  # programs.terraform.package = pkgs.terraform_1;
  # Override the default settings generated by the above option
  # settings.formatter.terraform.excludes = [ "hello.tf" ];
}
