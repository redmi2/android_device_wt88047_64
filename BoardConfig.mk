# config.mk
#
# Product-specific compile-time definitions.
#


TARGET_BOARD_PLATFORM := msm8916
TARGET_BOOTLOADER_BOARD_NAME := msm8916

TARGET_COMPILE_WITH_MSM_KERNEL := true
TARGET_KERNEL_APPEND_DTB := false

# Assert
TARGET_OTA_ASSERT_DEVICE := wt88047_64,WT88047_64,wt88047,WT88047,wt86047,WT86047,HM2014811,HM2014812,HM2014813,HM2014814,HM2014815,HM2014816,HM2014817,HM2014818,HM2014819,HM2014820,HM2014821

USE_CLANG_PLATFORM_BUILD := true

-include $(QCPATH)/common/msm8916/BoardConfigVendor.mk
-include vendor/xiaomi/wt88047/BoardConfigVendor.mk

NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

TARGET_NO_BOOTLOADER := true
TARGET_NO_KERNEL := false

BOOTLOADER_PLATFORM := msm8916# use msm8952 LK configuration

#MALLOC_IMPL := dlmalloc
MALLOC_SVELTE := true

#oad keymaster TA from HLOS
TARGET_VB_NOT_ENABLED := true

TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 0x02000000
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x02000000
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1073741824
BOARD_USERDATAIMAGE_PARTITION_SIZE := 5939100672
BOARD_CACHEIMAGE_PARTITION_SIZE := 335544320
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PERSISTIMAGE_PARTITION_SIZE := 33554432
BOARD_PERSISTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_FLASH_BLOCK_SIZE := 131072 # (BOARD_KERNEL_PAGESIZE * 64)

# Added to indicate that protobuf-c is supported in this build
PROTOBUF_SUPPORTED := true

# Time services
BOARD_USES_QC_TIME_SERVICES := true
  
# Flags
#COMMON_GLOBAL_CFLAGS += -DNO_SECURE_DISCARD -DCAMERA_VENDOR_L_COMPAT

TARGET_USES_ION := true
TARGET_USES_NEW_ION_API :=true
TARGET_NO_RPC := true

# SDClang configuration
#SDCLANG := true
SDCLANG := false
####SDCLANG_PATH := prebuilts/clang/linux-x86/host/sdclang-3.8/bin
#SDCLANG_PATH := prebuilts/clang/host/linux-x86/4/bin
#SDCLANG_LTO_DEFS := device/qcom/common/sdllvm-lto-defs.mk


# Enable CSVT
TARGET_USES_CSVT := true

BOARD_KERNEL_CMDLINE := console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 no_console_suspend=1 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlyprintk androidboot.selinux=permissive
BOARD_KERNEL_SEPARATED_DT := true

BOARD_SECCOMP_POLICY := device/wt88047_64/seccomp

BOARD_CUSTOM_BOOTIMG_MK  := device/wt88047_64/mkbootimg.mk
BOARD_MKBOOTIMG_ARGS     := --ramdisk_offset 0x02000000 --tags_offset 0x01E00000
BOARD_DTBTOOL_ARGS       := -2

BOARD_KERNEL_BASE        := 0x80000000
BOARD_KERNEL_PAGESIZE    := 2048
BOARD_KERNEL_TAGS_OFFSET := 0x01E00000
BOARD_RAMDISK_OFFSET     := 0x02000000

TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_CROSS_COMPILE_PREFIX := aarch64-linux-android-
TARGET_USES_UNCOMPRESSED_KERNEL := false

# Adreno
OVERRIDE_RS_DRIVER := libRSDriver_adreno.so
TARGET_CONTINUOUS_SPLASH_ENABLED := false
TARGET_USES_C2D_COMPOSITION := true

ifeq ($(ENABLE_VENDOR_IMAGE), true)
BOARD_VENDORIMAGE_PARTITION_SIZE := 524288000
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
endif

# Shader cache config options
# Maximum size of the  GLES Shaders that can be cached for reuse.
# Increase the size if shaders of size greater than 12KB are used.
MAX_EGL_CACHE_KEY_SIZE := 12*1024

# Maximum GLES shader cache size for each app to store the compiled shader
# binaries. Decrease the size if RAM or Flash Storage size is a limitation
# of the device.
MAX_EGL_CACHE_SIZE := 2048*1024

BOARD_EGL_CFG := device/wt88047_64/egl.cfg
TARGET_PLATFORM_DEVICE_BASE := /devices/soc.0/
# Add NON-HLOS files for ota upgrade
ADD_RADIO_FILES := true

#adb
TARGET_USES_LEGACY_ADB_INTERFACE := true

TARGET_RECOVERY_UPDATER_LIBS += librecovery_updater_msm
TARGET_INIT_VENDOR_LIB := libinit_msm

# init
TARGET_LIBINIT_DEFINES_FILE := device/wt88047_64/init/init_wt88047.cpp

#add suffix variable to uniquely identify the board
TARGET_BOARD_SUFFIX := _64

# Audio
AUDIO_FEATURE_ENABLED_PM_SUPPORT := false
AUDIO_FEATURE_ENABLED_SSR := false
AUDIO_FEATURE_ENABLED_EXTN_RESAMPLER := false
BOARD_SUPPORTS_SOUND_TRIGGER := false

#Camera
BOARD_CAMERA_SENSORS := \
    ov2680_5987fhq \
    ov8865_q8v18a \
    ov2680_skuhf
USE_DEVICE_SPECIFIC_CAMERA := true
TARGET_HAS_LEGACY_CAMERA_HAL1 := true
TARGET_TS_MAKEUP := true

# For the Legacy blobs
TARGET_NEEDS_PLATFORM_TEXT_RELOCATIONS := true

#GPS
BOARD_VENDOR_QCOM_GPS_LOC_API_HARDWARE := $(TARGET_BOARD_PLATFORM)

# Recovery
TARGET_RECOVERY_FSTAB := device/wt88047_64/fstab.qcom
#TARGET_RECOVERY_FSTAB := device/wt88047_64/recovery.fstab

#Enable HW based full disk encryption
#TARGET_HW_DISK_ENCRYPTION := false

#Enable SW based full disk encryption
#TARGET_SWV8_DISK_ENCRYPTION := true

TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true

MAX_VIRTUAL_DISPLAY_DIMENSION := 2048

# Enable sensor multi HAL
#USE_SENSOR_MULTI_HAL := true

# Vold
TARGET_USE_CUSTOM_LUN_FILE_PATH := /sys/devices/platform/msm_hsusb/gadget/lun%d/file

FEATURE_QCRIL_UIM_SAP_SERVER_MODE := true

# FM
TARGET_QCOM_NO_FM_FIRMWARE := true
AUDIO_FEATURE_ENABLED_FM_POWER_OPT := true
BOARD_HAVE_QCOM_FM := true

# Control flag between KM versions
#TARGET_HW_KEYMASTER_V03 := true

#Enable peripheral manager
TARGET_PER_MGR_ENABLED := true

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_QCOM := true
BLUETOOTH_HCI_USE_MCT := true

# Wifi
BOARD_HAS_QCOM_WLAN := true
BOARD_HAS_QCOM_WLAN_SDK := true
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_qcwcn
BOARD_WLAN_DEVICE := qcwcn
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_qcwcn
##?TARGET_USES_QCOM_WCNSS_QMI := true
##?TARGET_USES_WCNSS_CTRL := true
WIFI_DRIVER_FW_PATH_AP := "ap"
WIFI_DRIVER_FW_PATH_STA := "sta"
WPA_SUPPLICANT_VERSION := VER_0_8_X

WITH_DEXPREOPT := false
ifneq ($(TARGET_BUILD_VARIANT),user)
  # Retain classes.dex in APK's for non-user builds
  DEX_PREOPT_DEFAULT := nostripping
endif

