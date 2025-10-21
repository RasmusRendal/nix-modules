{
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;
    config = {
      alias.uncommit = "reset HEAD~";
      alias.tc = "commit -m \"SQUASH ME\" --no-gpg-sign";
      alias.ic = "commit --no-verify --no-gpg-sign";
      alias.unsign = "commit --amend --no-edit --no-verify --no-gpg-sign";
      core.editor = "hx";
      core.excludesFile = pkgs.writeText "gitignore" (builtins.readFile ./gitignore);
      help.autocorrect = "prompt";
      init.defaultBranch = "main";
      pager = {
        branch = false;
        stash = false;
      };
      pull.rebase = true;
      push.autoSetupRemote = true;
      rerere.enabled = true;
      user.email = "rasmus@rend.al";
      user.name = "Rasmus Rendal";
    };
  };
}
