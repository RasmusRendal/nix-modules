{
  unstable,
  ...
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit unstable; };
  home-manager.users.rendal =
    {
      config,
      pkgs,
      unstable,
      ...
    }:
    {
      programs.home-manager.enable = true;

      imports = [ ./helix.nix ];

      home.username = "rendal";
      home.homeDirectory = "/home/rendal";
      home.stateVersion = "22.05";
      programs.alacritty = {
        enable = true;
        settings.font.normal.family = "HackGenConsol eNF";
        settings.font.size = 10;
      };

    };
}
