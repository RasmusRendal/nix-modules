{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    (pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPrefs = builtins.readFile ./user.js;
    })
  ];
}
