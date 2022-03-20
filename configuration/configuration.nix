{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkIf
    mkMerge
  ;

  inherit (config.target-disk-mode) eink;
in
{
  imports = [
    ./options.nix
    ./initramfs.nix
  ];

  boot.cmdline = mkMerge [
    [
      "vt.global_cursor_default=0"
    ]
    (mkIf (!eink) [
      #                 BG                                 FG
      #                blk, red, grn, ylw, blu, mgt, cyn, wht, gry,bred,bgrn,bylw,bblu,bmgt,bcyn,bwht
      # White on purplish blue
      "vt.default_red=0x46,0xD0,0x00,0xB0,0x00,0xA0,0x4F,0xFF,0x99,0xFF,0x00,0xFF,0x00,0xFF,0x00,0xFF"
      "vt.default_grn=0x26,0x00,0xB0,0x66,0x00,0x00,0xB3,0xFF,0x99,0x00,0xFF,0xFF,0x00,0x00,0xFF,0xFF"
      "vt.default_blu=0x7E,0x00,0x00,0x00,0xB0,0xB0,0xC5,0xFF,0x99,0x00,0x00,0x00,0xFF,0xFF,0xFF,0xFF"
    ])
    (mkIf (eink) [
      #                 BG                                 FG
      #                blk, red, grn, ylw, blu, mgt, cyn, wht, gry,bred,bgrn,bylw,bblu,bmgt,bcyn,bwht
      # Black on white fbcon
      "vt.default_red=0xFF,0xBC,0x4F,0xB4,0x56,0xBC,0x4F,0x00,0xA1,0xCF,0x84,0xCA,0x8D,0xB4,0x84,0x68"
      "vt.default_grn=0xFF,0x55,0xBA,0xBA,0x4D,0x4D,0xB3,0x00,0xA0,0x8F,0xB3,0xCA,0x88,0x93,0xA4,0x68"
      "vt.default_blu=0xFF,0x58,0x5F,0x58,0xC5,0xBD,0xC5,0x00,0xA8,0xBB,0xAB,0x97,0xBD,0xC7,0xC5,0x68"
    ])
  ];

  wip.kernel = {
    structuredConfig = with lib.kernel; {
      # Basic features needed that may be removed by tinyconfig
      BLOCK = yes;
      USB_SUPPORT = yes;
      USB = yes;
      USB_ANNOUNCE_NEW_DEVICES = no;

      # To lazily report status on display...
      FRAMEBUFFER_CONSOLE = yes;
      VT_CONSOLE = yes;

      # TODO: "USB gadget" feature
      USB_GADGET = yes;
      USB_CONFIGFS = yes;
      USB_CONFIGFS_F_FS = yes;
      USB_CONFIGFS_MASS_STORAGE = yes;
      # Otherwise gadget battery may unexpectedly drain.
      # The default is `2`.
      USB_GADGET_VBUS_DRAW = freeform "500";

      # Minimize the size, as convenient
      MODULES = no;
      CC_OPTIMIZE_FOR_PERFORMANCE = no;
      CC_OPTIMIZE_FOR_SIZE = yes;

      # -----

      # 1000 Hz is the preferred choice for desktop systems and other
      # systems requiring fast interactive responses to events.
      HZ = freeform "1000";
      HZ_1000 = yes;

      SMP = yes;
    };
    features = {
      logo = true;
      printk = true;
      serial = true;
      vt = true;
      graphics = true;
    };
    logo =
      if eink
      then ./target-disk-mode.eink.png
      else ./target-disk-mode.png
    ;
  };

  wip.stage-1.compression = lib.mkDefault "xz";
}
