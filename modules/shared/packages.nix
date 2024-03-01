{ pkgs }:

with pkgs;

[
  # General packages for development and system management
  act
  alacritty
  aspell
  aspellDicts.en
  bash-completion
  bat
  btop
  coreutils
  killall
  mono
  neofetch
  openssh
  pandoc
  rnix-lsp
  sqlite
  wget
  zip

  # Encryption and security tools
  age
  age-plugin-yubikey
  bitwarden-cli
  gnupg
  libfido2
  pinentry
  yubikey-manager

  # Cloud-related tools and SDKs
  #
  # docker marked broken as of Nov 15, 2023
  # https://github.com/NixOS/nixpkgs/issues/267685
  #
  # docker
  # docker-compose
  #
  awscli2
  flyctl
  ngrok

  # Media-related packages
  dejavu_fonts
  emacs-all-the-icons-fonts
  fd
  ffmpeg
  font-awesome
  hack-font
  meslo-lgs-nf
  noto-fonts
  noto-fonts-emoji
  yt-dlp

  # Node.js development tools
  nodejs
  nodePackages.nodemon
  nodePackages.npm
  nodePackages.prettier

  # Text and terminal utilities
  htop
  hunspell
  iftop
  jetbrains-mono
  jq
  parallel
  ripgrep
  tmux
  tree
  unrar
  unzip
  zsh-powerlevel10k

  # Python packages
  python3
  python3Packages.virtualenv # globally install virtualenv
]
