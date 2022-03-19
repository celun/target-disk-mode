{ lib, pkgs, ... }:

{
  wip.kernel.package = pkgs.callPackage ./kernel {};
  wip.kernel.defconfig = pkgs.writeText "empty" "";

  wip.kernel = {
    structuredConfig = lib.mkMerge [
      (with lib.kernel; {
        ARCH_ROCKCHIP = yes;
        NR_CPUS = freeform "6";
        ARM_RK3399_DMC_DEVFREQ = yes;
      })

      (with lib.kernel; {
        CHARGER_GPIO = yes;
        BATTERY_RK818 = yes;
        CHARGER_RK818 = yes;
        IIO = yes;
      })

      (with lib.kernel; {
        EXTCON_USB_GPIO = yes;
        PHY_ROCKCHIP_INNO_USB2 = yes;
        PHY_ROCKCHIP_TYPEC = yes;
        PHY_ROCKCHIP_USB = yes;
        TYPEC = yes;
        TYPEC_FUSB302 = yes;
        TYPEC_TCPM = yes;
        USB_DWC3 = yes;
        TYPEC_EXTCON = yes;
        TYPEC_MUX_PI3USB30532 = yes;
        TYPEC_RT1711H = yes; /* Deps: */ TYPEC_TCPCI = yes;
        TYPEC_TPS6598X = yes;
      })

      (with lib.kernel; {
        DRM_ROCKCHIP = yes;
        DRM_PANFROST = yes;
        DRM_PANEL_SIMPLE = yes;
        DRM_PANEL_HIMAX_HX8394 = yes;
        # Deps:
        DRM = yes;
        DRM_BRIDGE = yes;
        PHY_ROCKCHIP_DP = yes;
        PHY_ROCKCHIP_INNO_HDMI = yes;
        ROCKCHIP_ANALOGIX_DP = yes;
        ROCKCHIP_DW_HDMI = yes;
        ROCKCHIP_IOMMU = yes;
        PHY_ROCKCHIP_INNO_DSIDPHY = yes;
        ROCKCHIP_DW_MIPI_DSI = yes;

        ### Transitive deps (forces it to be selected)
        DRM_ANALOGIX_DP = yes;
        DRM_DW_HDMI = yes;
        DRM_DW_MIPI_DSI = yes;
      })

      (with lib.kernel; {
        ROCKCHIP_SARADC = yes;
        # Deps:
        IIO = yes;
      })

      # RTC
      (with lib.kernel; {
        RTC_DRV_RK808 = yes;
        # Deps:
        RTC_CLASS = yes;
        MFD_RK808 = yes;
      })

      # Backlight
      (with lib.kernel; {
        BACKLIGHT_PWM = yes;
        # Deps:
        PWM = yes;
        PWM_ROCKCHIP = yes;
        BACKLIGHT_CLASS_DEVICE = yes;
      })

      # Power / regulators
      (with lib.kernel; {
        ROCKCHIP_IODOMAIN = yes;
        ROCKCHIP_PM_DOMAINS = yes;

        REGULATOR = yes;
        REGULATOR_FIXED_VOLTAGE = yes;
        REGULATOR_PWM = yes;
        REGULATOR_GPIO = yes;

        REGULATOR_FAN53555 = yes;
        REGULATOR_RK808 = yes;

        RC_CORE = yes;
        RC_MAP = yes;
        RC_DECODERS = yes;
        RC_DEVICES = yes;
      })

      # eMMC / SD
      (with lib.kernel; {
        MMC = yes;
        MMC_BLOCK = yes;

        PHY_ROCKCHIP_EMMC = yes;
        MMC_DW_ROCKCHIP = yes;
        MMC_DW = yes;
        MMC_SDHCI = yes;
        MMC_SDHCI_PLTFM = yes;
        MMC_SDHCI_OF_ARASAN = yes;

        # Undeclared dependency for mmc@fe320000
        I2C_RK3X = yes;
      })

      # TODO: move DMA_CMA in a generic location
      (with lib.kernel; {
        CMA = yes;
        DMA_CMA = yes;
        DMADEVICES = yes;
      })

      # TODO: review if/how it is needed
      # TODO: make generic
      (with lib.kernel; {
        ARM_CPUIDLE = yes;
        ARM_SCPI_CPUFREQ = yes;
        CPUFREQ_DT = yes;
        CPUFREQ_DT_PLATDEV = yes;
        CPU_IDLE = yes;
        CPU_IDLE_GOV_LADDER = yes;
        CPU_IDLE_MULTIPLE_DRIVERS = yes;
        DT_IDLE_STATES = yes;
        CPU_FREQ = yes;
        CPU_FREQ_GOV_ATTR_SET = yes;
        CPU_FREQ_GOV_COMMON = yes;
        CPU_FREQ_STAT = yes;
        CPU_FREQ_DEFAULT_GOV_ONDEMAND = yes;
        CPU_FREQ_GOV_CONSERVATIVE = yes;
        CPU_FREQ_GOV_ONDEMAND = yes;
        CPU_FREQ_GOV_PERFORMANCE = yes;
        CPU_FREQ_GOV_POWERSAVE = yes;
        CPU_FREQ_GOV_SCHEDUTIL = yes;
        CPU_FREQ_GOV_USERSPACE = yes;

        COMMON_CLK_SCPI = yes;
        ARM_SCPI_PROTOCOL = yes;
        MAILBOX = yes;
        ROCKCHIP_MBOX = yes;
      })

      # # SPI Flash support
      # (with lib.kernel; {
      #   SPI = yes;
      #   SPI_ROCKCHIP = yes;
      #   MTD = yes;
      #   MTD_SPI_NOR = yes;
      #   MTD_BLOCK = yes;
      # })

      # Input
      # (with lib.kernel; {
      #   KEYBOARD_ADC = yes;
      #   KEYBOARD_GPIO = yes;
      # 
      #   # dependencies for KEYBOARD_ADC
      #   ROCKCHIP_SARADC = yes;
      #   IIO = yes;
      #   INPUT_KEYBOARD = yes;
      # })
    ];
  };
}
