{
  lib,
  pkgs,
  ...
}:
let
  swaylock = pkgs.writeShellApplication {
    name = "swaylock";
    runtimeInputs = [ pkgs.swaylock-effects ];
    text = ''
      swaylock \
        --screenshots \
        --clock \
        --indicator \
        --indicator-radius 100 \
        --indicator-thickness 7 \
        --effect-blur 7x5 \
        --effect-vignette 0.5:0.5 \
        --ring-color bb00cc \
        --key-hl-color 880033 \
        --line-color 00000000 \
        --inside-color 00000088 \
        --separator-color 00000000 \
        --grace 2 \
        --fade-in 0.2
    '';
  };

in
{
  config = {
    programs.sway = {
      enable = true;
      package = pkgs.swayfx;
      wrapperFeatures.gtk = true;
    };

    programs.waybar = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      # Terminal emulator
      foot
      # Arrange displays
      nwg-displays
      # Take screenshot
      grim
      # Select screen
      slurp
      # Screenshot
      sway-contrib.grimshot
      # Screen recorder
      wf-recorder
      # Notification daemon
      wired
      # Lock screen, with blur
      swaylock
      # Notifications
      swaynotificationcenter
    ];

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      wlr.settings = {
        screencast = {
          # At some point, xdg-portal-wlr will support sharing a single window,
          # but there's still a bug where it only works with `max_fps` set to 60
          max_fps = 60;
          # chooser_type = "simple";
          # chooser_cmd = "${lib.getExe pkgs.slurp} -f 'Monitor: %o' -or";
          chooser_type = "dmenu";
          chooser_cmd = "${lib.getExe pkgs.fuzzel} -d";
        };
      };

    };

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };
}
