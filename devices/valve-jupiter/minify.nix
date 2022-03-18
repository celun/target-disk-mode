{ lib, ... }:

{
  wip.kernel = {
    structuredConfig = lib.mkMerge [
      # Slim down config somewhat
      # TODO: move into more general options
      (with lib.kernel; {
        ETHERNET = no;
        NETFILTER = no;
        BPFILTER = no;
        USB_NET_DRIVERS = no;
        WIRELESS = no;
        WIREGUARD = no;
        BT = no;
        WLAN = no;
        NETDEVICES = no;
        MMC = no;
        INET = no; # No TCP/IP networking
        ETHTOOL_NETLINK = no;
        SERIO = no;
        LEGACY_PTYS = no;
        HW_RANDOM = no;
        SND = no;
        IKHEADERS = no;

        CRYPTO_DEFLATE = no;
        CRYPTO_842 = no;
        CRYPTO_LZ4 = no;
        CRYPTO_LZ4HC = no;
        CRYPTO_ZSTD = no;

        # It's an AMD!
        PROCESSOR_SELECT = yes; /* deps: */ EXPERT = yes;
        CPU_SUP_AMD = yes;
        CPU_SUP_CENTAUR = no;
        CPU_SUP_HYGON = no;
        CPU_SUP_INTEL = no;
        CPU_SUP_ZHAOXIN = no;
      })

      (with lib.kernel; {
        # Relying on efifb is better for this specific use case
        DRM = no;
      })

      (with lib.kernel; {
        DEBUG_FS = no;
        BLK_DEBUG_FS = no;

        AFFS_FS = no;
        AUTOFS4_FS = no;
        AUTOFS_FS = no;
        BEFS_FS = no;
        BTRFS_FS = no;
        ECRYPT_FS = no;
        EFIVAR_FS = no;
        EROFS_FS = no;
        EXFAT_FS = no;
        EXT2_FS = no;
        EXT4_FS = no;
        F2FS_FS = no;
        FAT_FS = no;
        FSCACHE = no;
        FUSE_FS = no;
        GFS2_FS = no;
        HFS_FS = no;
        HFSPLUS_FS = no;
        ISO9660_FS = no;
        JFFS2_FS = no;
        JFS_FS = no;
        MINIX_FS = no;
        MSDOS_FS = no;
        NILFS2_FS = no;
        OMFS_FS = no;
        ORANGEFS_FS = no;
        OVERLAY_FS = no;
        REISERFS_FS = no;
        ROMFS_FS = no;
        UBIFS_FS = no;
        UDF_FS = no;
        UFS_FS = no;
        VBOXSF_FS = no;
        VFAT_FS = no;
        VIRTIO_FS = no;
        XFS_FS = no;
        ZONEFS_FS = no;
        ZONE_FS = no;
      })

      (with lib.kernel; {
        SYSVIPC = yes;
        POSIX_MQUEUE = yes;
        NO_HZ = yes;
        HIGH_RES_TIMERS = yes;
        PREEMPT_VOLUNTARY = yes;
        CC_OPTIMIZE_FOR_SIZE = yes;
        JUMP_LABEL = yes;
        NET = yes;
        PACKET = yes;
        PACKET_DIAG = yes;
        UNIX = yes;
        UNIX_DIAG = yes;
        INPUT_EVDEV = yes;
        INPUT_TOUCHSCREEN = yes;
        LOGO = yes;
        NEW_LEDS = yes;
        LEDS_CLASS = yes;
        RTC_CLASS = yes;
        CONSOLE_LOGLEVEL_DEFAULT = freeform "3";
        FRAME_WARN = freeform "1024";
        MAGIC_SYSRQ = yes;
        DEBUG_FS = yes;
        STACKTRACE = yes;

        STACKPROTECTOR = no;
        GCC_PLUGINS = no;
        WIRELESS = no;
        INPUT_MOUSEDEV = no;
        RTC_INTF_PROC = no;
      })

      # Disabling generally unneeded things
      (with lib.kernel; {
        MEDIA_SUBDRV_AUTOSELECT = no;
        NETWORK_FILESYSTEMS = no;
        RAID6_PQ_BENCHMARK = no;
        RUNTIME_TESTING_MENU = no;
        STRICT_DEVMEM = no;
        REMOTEPROC = no;
        RPMSG = no;
        VHOST_MENU = no;
        VIRTIO = no;
        I2C_VIRTIO = no;
        VIRTIO_CONSOLE = no;
        VIRTIO_MENU = no;
      })

      (with lib.kernel; {
      })

      (with lib.kernel; {
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
