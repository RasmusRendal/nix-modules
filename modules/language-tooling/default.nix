{
  pkgs,
  ...
}:
let
  dict = pkgs.callPackage ./dict.nix { };
  translate = pkgs.callPackage ./translate.nix { };
in
{
  environment.systemPackages = [
    dict
    translate
  ];

  services.ollama = {
    enable = true;
    loadModels = [ "translategemma:4b" ];
  };
}
