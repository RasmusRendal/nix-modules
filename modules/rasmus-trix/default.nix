{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
{
  options.services.matrix-notify = {
    enable = mkEnableOption "Enable matrix notifier service";

    credentialsFile = mkOption {
      type = types.path;
      default = null;
      example = "/etc/nixos/matrix-credentials.json";
      description = lib.mkDoc ''
        Credentials file generated with matrix-commander --login
      '';
    };

    user = mkOption {
      type = types.str;
      default = null;
      example = "@rasmus:matrix.org";
      description = lib.mkDoc ''
        Matrix user who is allowed to issue commands using rasmus-trix
      '';
    };

    room = mkOption {
      type = types.str;
      default = null;
      example = "!someroom:matrix.org";
      description = lib.mkDoc ''
        Room in which the bot is receiving commands
      '';
    };

    scripts = mkOption {
      default = [ ];
      type = types.listOf types.path;
      description = "A list of scripts. For any message received, the first word is the filename, the subsequent words are arguments";
    };

  };
  config =
    let
      cfg = config.services.matrix-notify;
    in
    mkIf cfg.enable {
      users.groups.matrix-commander = {
      };

      users.users.matrix-commander = {
        isSystemUser = true;
        group = "matrix-commander";
        home = "/var/lib/matrix-commander";
        createHome = true;
      };

      systemd.services."matrix-bot" = {
        path = with pkgs; [
          matrix-commander
          fish
          jq
        ];
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart =
            let
              folder = pkgs.runCommand "scriptfolderbuilder" { } (
                ''
                  mkdir $out;
                  cd $out;
                ''
                + (lib.concatStrings (map (script: "ln -s ${script}/bin/* ./;") cfg.scripts))
              );
            in
            pkgs.writeTextFile {
              name = "bot";
              text = builtins.readFile ./bot.sh;
              executable = true;
            }
            + " --credentials ${cfg.credentialsFile} --store /var/lib/matrix-commander/store --folder ${folder} --room ${cfg.room} --user ${cfg.user}";
          User = "matrix-commander";
          Group = "matrix-commander";
        };
      };

      systemd.services."matrix-notify@" = {
        script = ''
          set -eu
            ${pkgs.matrix-commander}/bin/matrix-commander --credentials ${cfg.credentialsFile} --store /var/lib/matrix-commander/store -m "$(systemd-escape -u $@)"
        '';
        scriptArgs = "%i";
        serviceConfig = {
          Type = "oneshot";
          User = "matrix-commander";
        };
      };
    };
}
