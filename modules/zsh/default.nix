{
  lib,
  pkgs,
  ...
}:
let
  zsh-helix-mode = pkgs.fetchFromGitHub {
    owner = "Multirious";
    repo = "zsh-helix-mode";
    rev = "f9d72d23f5ce12da31967a6ecd15dcafa1355fa7";
    sha256 = "sha256-wiUocowz3uL3fTAxTfG3URhOwB2RrFWEmUnW4k0ETJ4=";
  };
  # zsh hook which prints the current working directory in OSC7 format. When
  # I open a new terminal with CTRL+SHIFT+N, the new terminal will have the
  # same working directory as the existing one.
  osc7_hook = ''
    function print_osc7() {
      if [ "$ZSH_SUBSHELL" -eq 0 ] ; then
          printf "\033]7;file://$HOST/$PWD\033\\"
      fi
    }
    autoload -Uz add-zsh-hook
    add-zsh-hook -Uz chpwd print_osc7
    print_osc7
  '';
in
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      rsync = "rsync --info=progress2";
      ergedox_flash = "teensy-loader-cli -mmcu=atmega32u4 -w";
    }
    // (
      let
        ndots = x: lib.concatStrings (lib.replicate x ".");
        ndirs = x: lib.concatStrings (lib.replicate x "../");
        alias = x: {
          name = ndots (x + 1);
          value = "cd ${ndirs x}";
        };
      in
      builtins.listToAttrs (map alias (lib.range 1 10))
    );

    promptInit = ''
      export BROWSER=firefox
      export EDITOR=hx
      eval $(${lib.getExe pkgs.starship} init zsh)
      # Search history with initial parts of command filled in
      bindkey "$terminfo[kcuu1]" history-beginning-search-backward
      bindkey "$terminfo[kcud1]" history-beginning-search-forward
      # CTRL left+right
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list ''' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*:default' list-colors ''${(s.:.)LS_COLORS}
      ${osc7_hook}
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      format = lib.replaceString "\n" "" ''
        $username
        $hostname
        $localip
        $shlvl
        $singularity
        $kubernetes
        $directory
        ''${custom.jj}
        $memory_usage
        $direnv
        $env_var
        $cmd_duration
        $line_break
        $jobs
        $time
        $status
        $os
        $netns
        $shell
        $character'';

      # Mostly copied from https://github.com/jj-vcs/jj/wiki/Starship#alternative-prompt
      custom.jj = {
        command = ''
          jj log --revisions @ --no-graph --ignore-working-copy --color always --limit 1 --template '
            separate(" ",
              change_id.shortest(4),
              bookmarks,
              "|",
              concat(
                if(conflict, "💥"),
                if(divergent, "🚧"),
                if(hidden, "👻"),
                if(immutable, "🔒"),
              ),
              raw_escape_sequence("\x1b[1;32m") ++ if(empty, "(empty)"),
              raw_escape_sequence("\x1b[1;32m") ++ coalesce(
                truncate_end(29, description.first_line(), "…"),
                "(no description set)",
              ) ++ raw_escape_sequence("\x1b[0m"),
            )
          '        '';
        when = "jj --ignore-working-copy root";
        symbol = "jj";
      };
    };
  };
}
