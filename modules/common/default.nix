{
  pkgs,
  unstable,
  ...
}:
{
  boot.tmp.cleanOnBoot = true;

  i18n.defaultLocale = "en_DK.UTF-8";
  time.timeZone = "Europe/Amsterdam";
  console = {
    keyMap = "dvorak-programmer";
    font = "Lat2-Terminus16";
  };

  services.libinput.enable = true;
  services.xserver.xkb.layout = "us,ru";
  services.xserver.xkb.variant = "dvp,";
  services.xserver.xkb.options = "compose:ralt,caps:super";

  users.users.rendal = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
    ];
    shell = pkgs.zsh;
  };

  fonts.packages = with pkgs; [
    fantasque-sans-mono
    powerline-fonts
    powerline-symbols
    hack-font
    garamond-libre
    noto-fonts-cjk-serif
    noto-fonts-cjk-sans
    hackgen-nf-font
  ];

  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    bc
    file
    fzf
    fzy
    gdb
    gh
    gimp
    gitFull
    gnupg
    htop
    inotify-tools
    jq
    kdePackages.okular
    keepassxc
    killall
    libreoffice
    man-pages
    moreutils
    p7zip
    pavucontrol
    progress
    radare2
    ripgrep
    ripgrep-all
    shellcheck
    sshfs
    sqlite
    tmux
    unstable.jujutsu
    unzip
    wget
    xdg-utils
    zip
  ];

  programs.direnv = {
    enable = true;
    loadInNixShell = true;
    nix-direnv = {
      enable = true;
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
