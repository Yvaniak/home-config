{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    zsh.enable = lib.mkEnableOption "enable zsh module";
  };

  config = lib.mkIf config.zsh.enable {
    home.packages = [ pkgs.pokemon-colorscripts-mac ];
    programs = {
      zoxide.enable = true;
      zoxide.enableZshIntegration = true;

      starship = {
        enable = true;
        enableZshIntegration = true;
      };

      zsh = {
        enable = true;
        oh-my-zsh = {
          enable = true;
          theme = "agnoster";
          plugins = [
            "sudo"
            "git"
          ];
        };

        initContent = ''

          # Use vim bindings.
          set -o vi


          pokemon-colorscripts -r
        '';

        sessionVariables = {
          FLAKE = "/home/$USER/projets/coding/home-config";
          NH_FLAKE = "/home/$USER/projets/coding/home-config";
          NIXPKGS_ALLOW_UNFREE = 1;
        };

        shellAliases = {
          v = "nvim";
          hv = "h nvim";
          vs = "codium";
          cd = "z";
          lofi = "mpv https://www.youtube.com/watch\\?v\\=jfKfPfyJRdk --no-video";
          f = "ssh -A -Y ewen.philippot@etu.umontpellier.fr@x2go.umontpellier.fr";
          lg = "lazygit";
          cat = "bat";
        };

        plugins = [
          {
            name = "zsh-nix-shell";
            file = "nix-shell.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "chisui";
              repo = "zsh-nix-shell";
              rev = "v0.4.0";
              sha256 = "037wz9fqmx0ngcwl9az55fgkipb745rymznxnssr3rx9irb6apzg";
            };
          }
        ];

        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        enableCompletion = true;
        autocd = true;
      };

      pay-respects = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
