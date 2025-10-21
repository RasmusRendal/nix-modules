{
  description = "Rasmus' big pile of NixOS modules. Peruse at your own peril";

  outputs =
    { self }:
    {
      nixosModules.x86_64-linux = {
        # Module consisting of everything besides besides niri
        default = {
          imports = [
            ./modules/common
            ./modules/firefox
            ./modules/git
            ./modules/home
            ./modules/zsh
          ];
        };
        common = ./modules/common;
        firefox = ./modules/firefox;
        git = import ./modules/git;
        home = import ./modules/home;
        niri = import ./modules/niri;
        rasmus-trix = import ./modules/rasmus-trix;
        zsh = ./modules/zsh;
      };
    };
}
