{
  pkgs,
  unstable,
  ...
}:
{
  programs.helix = {
    enable = true;
    package = unstable.helix;
    extraPackages =
      with pkgs;
      with python3Packages;
      [
        nil
        lldb
        gopls
        texlab
        python-lsp-server
        ruff
        black
      ];
    settings = {
      theme = "fleet_dark";
      editor = {
        rulers = [ 80 ];
        soft-wrap.enable = true;
        inline-diagnostics = {
          cursor-line = "warning";
        };
      };
    };
    languages.language-server.pylsp.config.pylsp = {
      plugins.ruff.enabled = true;
      plugins.black.enabled = true;
      plugins.pylint.enabled = true;
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
      }
    ];
  };
}
