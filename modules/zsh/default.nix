{
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      e = "eza";
      rsync = "rsync --info=progress2";
      yt-dlp = "yt-dlp --embed-subs";
    };
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "direnv"
        "vi-mode"
        "fzf"
      ];
      customPkgs = with pkgs; [ spaceship-prompt ];
      theme = "spaceship";
    };

    promptInit = builtins.readFile ./zshrc;
  };
}
