{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    mako
    waybar
  ];

  programs.niri.enable = true;

  environment.etc."xdg/waybar/config.jsonc".source = ./waybar.config.jsonc;
  environment.etc."niri/config.kdl".source = ./niri.config.kdl;

  # xdg = {
  #   mime.enable = true;
  #   icons.enable = true;

  #   portal.enable = true;
  #   portal.extraPortals = [
  #     pkgs.xdg-desktop-portal-gnome
  #     pkgs.xdg-desktop-portal-gtk
  #   ];
  #   portal.configPackages = [ pkgs.gnome-session ];
  # };

  security.pam.services.swaylock = { };
  security.polkit.enable = true;
}
