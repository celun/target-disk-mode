{ config, lib, pkgs, ... }:

{
  device = {
    name = "chuwi/hi10prohq64";
  };

  hardware = {
    cpu = "generic-x86_64";
  #  cpu = "intel-atom-x5-z8350";
  };

  wip.uefi.enable = true;

  wip.kernel.package = pkgs.callPackage ./kernel {};
  wip.kernel.defconfig = ./kernel/config.x86_64;

  boot.cmdline = [
    "drm.vblankoffdelay=1"
    "vt.global_cursor_default=0"
    "console=tty2"
    "loglevel=0"
  ];

  wip.kernel = {
    structuredConfig = lib.mkMerge [
      # Slim down config somewhat
      # TODO: move into more general options
      (with lib.kernel; {
        NETFILTER = no;
        BPFILTER = no;
        USB_NET_DRIVERS = no;
        WIRELESS = no;
        WIREGUARD = no;
        BT = no;
        WLAN = no;
        NETDEVICES = no;
        INET = no; # No TCP/IP networking
        ETHTOOL_NETLINK = no;
        SERIO = no;
        LEGACY_PTYS = no;
        HW_RANDOM = no;
        SND = no;

        CRYPTO_DEFLATE = no;
        CRYPTO_842 = no;
        CRYPTO_LZ4 = no;
        CRYPTO_LZ4HC = no;
        CRYPTO_ZSTD = no;

      })

      (with lib.kernel; {
        # Relying on efifb is better for this specific use case
        DRM = no;
      })

      (with lib.kernel; {
        DEBUG_FS = no;
        BLK_DEBUG_FS = no;

        AUTOFS_FS = no;

        EXT4_FS = no;
        EXT2_FS = no;
        FAT_FS = no;
        VFAT_FS = no;
      })

      (with lib.kernel; {
        SYSVIPC = yes;
        POSIX_MQUEUE = yes;
        NO_HZ = yes;
        HIGH_RES_TIMERS = yes;
        PREEMPT_VOLUNTARY = yes;
        CC_OPTIMIZE_FOR_SIZE = yes;
        JUMP_LABEL = yes;
        STACKPROTECTOR = no;
        GCC_PLUGINS = no;
        NET = yes;
        PACKET = yes;
        PACKET_DIAG = yes;
        UNIX = yes;
        UNIX_DIAG = yes;
        WIRELESS = no;
        INPUT_MOUSEDEV = yes;
        INPUT_MOUSEDEV_PSAUX = yes;
        INPUT_EVDEV = yes;
        KEYBOARD_GPIO = yes;
        KEYBOARD_GPIO_POLLED = yes;
        INPUT_TOUCHSCREEN = yes;
        LOGO = yes;
        MMC = yes;
        NEW_LEDS = yes;
        LEDS_CLASS = yes;
        LEDS_GPIO = yes;
        RTC_CLASS = yes;
        RTC_INTF_PROC = no;
        CONSOLE_LOGLEVEL_DEFAULT = freeform "3";
        FRAME_WARN = freeform "1024";
        MAGIC_SYSRQ = yes;
        DEBUG_FS = yes;
        STACKTRACE = yes;
      })

      # Disabling generally unneeded things
      (with lib.kernel; {
        MEDIA_SUBDRV_AUTOSELECT = no;
        NETWORK_FILESYSTEMS = no;
        RAID6_PQ_BENCHMARK = no;
        RUNTIME_TESTING_MENU = no;
        STRICT_DEVMEM = no;
        VHOST_MENU = no;
        VIRTIO_MENU = no;

        HID_A4TECH = no;
        HID_APPLE = no;
        HID_BELKIN = no;
        HID_CHERRY = no;
        HID_CHICONY = no;
        HID_CYPRESS = no;
        HID_EZKEY = no;
        HID_ITE = no;
        HID_KENSINGTON = no;
        HID_LOGITECH = no;
        HID_REDRAGON = no;
        HID_MICROSOFT = no;
        HID_MONTEREY = no;
        INPUT_MOUSE = no;
        KEYBOARD_ATKBD = no;
      })
    ];
  };
}
