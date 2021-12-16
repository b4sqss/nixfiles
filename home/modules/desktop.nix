{ config, pkgs, ... }:
let
  clr = import ../theme/tomorrow-night.nix;
in

{
   home.packages = with pkgs; [
     xwallpaper
     pamixer
     i3lock-color
     brightnessctl
     redshift
   ];

  gtk = {
    font = {
      name = "JetBrains Mono";
      size = "10";
    };
    # theme = "everforest-gtk";
    theme = "tomorrow-night";
    iconTheme.name = "vimix black";
  };
  services.screen-locker = {
    enable = true;
    inactiveInterval = 5;
    lockCmd = "/bin/sh /home/basqs/.local/bin/lock.sh";
  };

  services.sxhkd = {
    enable = true;
    keybindings = {
      "super + o" = "firefox -P Normal";

      "super + shift + o" = "firefox -P contas";

      "super + shift + a" = "emacs";

      "super + w" = "brave";

      "super + Escape" = "pkill -USR1 -x sxhkd";

      "super + {s,n,m,z}" = "{~/.local/bin/dmenu_websearch,~/.local/bin/dmenuumount,~/.local/bin/dmenumount,~/.local/bin/dmenuhandler}";

      "XF86AudioPlay" = "mpc toggle";

      "XF86AudioPrev" = "mpc prev";

      "XF86AudioNext" = "mpc next";

      "Print" = "scrot  -e 'mv $f ~/Pictures/screenshots'";

      "XF86AudioRaiseVolume" = "pamixer -i 5";

      "XF86AudioLowerVolume" = "pamixer -d 5";

      "XF86AudioMute" = "pamixer -t";

      "XF86MonBrightnessDown" = "brightnessctl set 10%-";

      "XF86MonBrightnessUp" = "brightnessctl set +10%";
    };
  };

xdg.mime.enable = true;
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "application/pdf" = "zathura.desktop";

    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";

    "application/x-bittorrent" = "com.transmissionbt.Transmission.desktop";
    "x-scheme-handler/magnet" = "com.transmissionbt.Transmission.desktop";

    "application/vnd.apple.mpegurl" = "mpv.desktop";
    "application/x-mpegurl" = "mpv.desktop";
    "video/3gpp" = "mpv.desktop";
    "video/mp4" = "mpv.desktop";
    "video/mpeg" = "mpv.desktop";
    "video/ogg" = "mpv.desktop";
    "video/quicktime" = "mpv.desktop";
    "video/webm" = "mpv.desktop";
    "video/x-m4v" = "mpv.desktop";
    "video/ms-asf" = "mpv.desktop";
    "video/x-ms-wmv" = "mpv.desktop";
    "video/x-msvideo" = "mpv.desktop";
  };
xresources.properties = {
  "*background" = clr.background;
  "*foreground" = clr.foreground;

  "*color0" =  clr.black;
  "*color8" =  clr.black-br;

  "*color1" =  clr.red;
  "*color9" =  clr.red-br;

  "*color2" =  clr.green;
  "*color10" = clr.green-br;

  "*color3" =  clr.yellow;
  "*color11" = clr.yellow-br;

  "*color4" =  clr.blue;
  "*color12" = clr.blue-br;

  "*color5" =  clr.magenta;
  "*color13" = clr.magenta-br;

  "*color6" =  clr.cyan;
  "*color14" = clr.cyan-br;
  
  "*color7" =  clr.white;
  "*color15" = clr.white-br;

  "*.font" = "JetBrains Mono";
};

home.file.".xinitrc".source = ../configs/xinitrc;

 #  xsession = {
 #  enable = true;
 #  windowManager.i3.enable = true;
 #  windowManager.xmonad = {
 #     enable = true;
 #     enableContribAndExtras = true;
 #     config = ../configs/xmonad/xmonad.hs;
 #     };
 # };

}
