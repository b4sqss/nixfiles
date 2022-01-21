{ config, pkgs, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';

in {
  imports = [
    ./hardware-configuration.nix
    # ./hosts.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelModules = [ "kvm-intel" "vfio-pci" "nvidia" ];
    kernelParams = [ "workqueue.power_efficient=y" "intel_iommu=on" "iommu=pt" ];
  };

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    networkmanager.wifi.powersave = true;
    interfaces.enp60s0.useDHCP = true;
    interfaces.wlp61s0.useDHCP = true;
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  services = {
    upower.enable = true;
    acpid.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    journald.extraConfig = "MaxRetentionSec=2day";

    cron = {
      enable = true;
      systemCronJobs = [
        "0 0 * * 0      root    fstrim /"
      ];
    };

    xserver = {
      enable = true;
      displayManager.sddm.enable = false;
      displayManager.sx.enable = true;
      windowManager.bspwm.enable = true;
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = hpkgs: [
          hpkgs.xmonad
          hpkgs.xmonad-contrib
          hpkgs.xmonad-extras
        ];
      };

      videoDrivers = [ "nvidia" ];
      useGlamor = true;
      deviceSection = ''
        Option "DRI" "2"
        Option "TearFree" "true"
      '';
      layout = "br";
      xkbOptions = "caps:swapescape";

      libinput = {
        enable = true;
        touchpad.naturalScrolling = false;
      };
    };
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    nvidia.prime = {
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = [
        pkgs.libGL_driver
        pkgs.intel-compute-runtime
      ];
    };
  };

  virtualisation.libvirtd.enable = true;

  users.users.basqs = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" ];
  };

  security.sudo.enable = false;
  security.doas.enable = true;
  security.doas.extraRules = [{
    users = [ "basqs" ];
    keepEnv = true;
    persist = true;
  }];
  security.doas.extraConfig = ''
permit nopass :wheel as root cmd /run/current-system/sw/bin/reboot
permit nopass :wheel as root cmd /run/current-system/sw/bin/poweroff
permit nopass :wheel as root cmd /run/current-system/sw/bin/mount
permit nopass :wheel as root cmd /run/current-system/sw/bin/umount
permit nopass :wheel as root cmd /run/current-system/sw/bin/nixos-rebuild
'';

  documentation.dev.enable = true;
  documentation.man.enable = true;
  documentation.man.generateCaches = true;
  documentation.nixos.enable = true;
  environment.extraOutputsToInstall = [ "info" "man" "devman" ];

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # terminal stuff
    htop 
    neovim
    wget
    mu
    pulsemixer 
    ripgrep 

    mesa
    nvidia-offload

    steam
    lutris

    dconf

    protontricks
    # nix-gaming.packages.x86_64-linux.wine-tkg

    qemu_full
    virt-manager
    libvirt

    xorg.xf86videointel
    xorg.xf86inputevdev
    xorg.xf86inputsynaptics
    xorg.xf86inputlibinput
    xmobar

    w3m

    rsync
    nnn
    gitAndTools.gitFull

    clang
    clang-tools
    cppcheck
    gcc
    gnumake
    cmake
    valgrind
    binutils
    lld
    llvm
    ccls
  ];

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" "SourceCodePro" "IBMPlexMono" "CascadiaCode" "Terminus" ]; })
    scientifica
    cozette
  ];

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    package = pkgs.nixFlakes;
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";    };
    autoOptimiseStore = true;
    optimise.automatic = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
  system.autoUpgrade.enable = true;
}