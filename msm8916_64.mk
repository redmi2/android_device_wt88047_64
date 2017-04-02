DEVICE_PACKAGE_OVERLAYS := device/wt88047_64/overlay

TARGET_USES_QCOM_BSP := true
# Add QC Video Enhancements flag
TARGET_ENABLE_QC_AV_ENHANCEMENTS := true

#QTIC flag
-include $(QCPATH)/common/config/qtic-config.mk

#for android_filesystem_config.h
PRODUCT_PACKAGES += \
    fs_config_files

# Enable features in video HAL that can compile only on this platform
#TARGET_USES_MEDIA_EXTENSIONS := true

# World APN list
PRODUCT_COPY_FILES += \
    device/wt88047_64/configs/apns-conf.xml:system/etc/apns-conf.xml

# Selective SPN list for operator number who has the problem.
PRODUCT_COPY_FILES += \
    device/wt88047_64/configs/selective-spn-conf.xml:system/etc/selective-spn-conf.xml

# media_profiles and media_codecs xmls for redmi2
ifeq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS), true)
PRODUCT_COPY_FILES += device/wt88047_64/media/media_profiles_8916.xml:system/etc/media_profiles.xml \
                      device/wt88047_64/media/media_codecs_performance_8916_64.xml:system/etc/media_codecs_performance.xml \
                      device/wt88047_64/media/media_codecs_8916.xml:system/etc/media_codecs.xml
endif

TARGET_USES_NQ_NFC := false

PRODUCT_PROPERTY_OVERRIDES += \
           dalvik.vm.heapgrowthlimit=128m
$(call inherit-product, device/qcom/common/common64.mk)

# When can normal compile this module,  need module owner enable below commands
# font rendering engine feature switch
-include $(QCPATH)/common/config/rendering-engine.mk
ifneq (,$(strip $(wildcard $(PRODUCT_RENDERING_ENGINE_REVLIB))))
     MULTI_LANG_ENGINE := REVERIE
#    MULTI_LANG_ZAWGYI := REVERIE
endif

PRODUCT_BOOT_JARS += qcom.fmradio

# QMI
PRODUCT_PACKAGES += \
    dsi_config.xml \
    netmgr_config.xml \
    qmi_config.xml

# GPS
PRODUCT_PACKAGES += \
    gps.msm8916
    
PRODUCT_COPY_FILES += \
    device/wt88047_64/configs/flp.conf:system/etc/flp.conf \
    device/wt88047_64/configs/gps.conf:system/etc/gps.conf \
    device/wt88047_64/configs/quipc.conf:system/etc/quipc.conf \
    device/wt88047_64/configs/sap.conf:system/etc/sap.conf

#PRODUCT_BOOT_JARS += vcard
PRODUCT_BOOT_JARS += tcmiface
#PRODUCT_BOOT_JARS += qcmediaplayer

# QTI extended functionality of android telephony.
# Required for MSIM manual provisioning and other related features.
PRODUCT_PACKAGES += telephony-ext
PRODUCT_BOOT_JARS += telephony-ext

ifneq ($(strip $(QCPATH)),)
#PRODUCT_BOOT_JARS += com.qti.dpmframework
#PRODUCT_BOOT_JARS += dpmapi
PRODUCT_BOOT_JARS += oem-services
#PRODUCT_BOOT_JARS += com.qti.location.sdk
endif

PRODUCT_BOOT_JARS += WfdCommon

# default is nosdcard, S/W button enabled in resource
PRODUCT_CHARACTERISTICS := nosdcard

#Android EGL implementation
PRODUCT_PACKAGES += libGLES_android


PRODUCT_PACKAGES += \
    libqcomvisualizer \
    libqcompostprocbundle \
    libqcomvoiceprocessing


# Audio configuration od AOSP
PRODUCT_COPY_FILES += \
    device/wt88047_64/audio/acdb/Bluetooth_cal.acdb:system/etc/acdbdata/QRD/Bluetooth_cal.acdb \
    device/wt88047_64/audio/acdb/General_cal.acdb:system/etc/acdbdata/QRD/General_cal.acdb \
    device/wt88047_64/audio/acdb/Global_cal.acdb:system/etc/acdbdata/QRD/Global_cal.acdb \
    device/wt88047_64/audio/acdb/Handset_cal.acdb:system/etc/acdbdata/QRD/Handset_cal.acdb \
    device/wt88047_64/audio/acdb/Hdmi_cal.acdb:system/etc/acdbdata/QRD/Hdmi_cal.acdb \
    device/wt88047_64/audio/acdb/Headset_cal.acdb:system/etc/acdbdata/QRD/Headset_cal.acdb \
    device/wt88047_64/audio/acdb/Speaker_cal.acdb:system/etc/acdbdata/QRD/Speaker_cal.acdb \
    device/wt88047_64/audio/audio_effects.conf:system/vendor/etc/audio_effects.conf \
    device/wt88047_64/audio/audio_platform_info.xml:system/etc/audio_platform_info.xml \
    device/wt88047_64/audio/audio_policy.conf:system/etc/audio_policy.conf \
    device/wt88047_64/audio/mixer_paths.xml:system/etc/mixer_paths.xml \
    device/wt88047_64/audio/mixer_paths_qrd_skui.xml:system/etc/mixer_paths_qrd_skui.xml

# Audio configuration file
-include $(TOPDIR)hardware/qcom/audio/configs/msm8916_64/msm8916_64.mk

# Keylayout
PRODUCT_COPY_FILES += \
    device/wt88047_64/keylayout/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl \
    device/wt88047_64/keylayout/msm8x16-wt88047-snd-card_Button_Jack.kl:system/usr/keylayout/msm8x16-wt88047-snd-card_Button_Jack.kl \
    device/wt88047_64/keylayout/ft5x06_ts.kl:system/usr/keylayout/ft5x06_ts.kl

# Sensors
PRODUCT_PACKAGES += \
    calmodule.cfg \
    libcalmodule_common \
    sensors.msm8916
    
# Build libstlport for legacy blobs
PRODUCT_PACKAGES += \
    libstlport

# Display
PRODUCT_PACKAGES += \
    libtinyxml
	
# Camera
PRODUCT_PACKAGES += \
    libmm-qcamera \
    libshim_camera \
    libboringssl-compat

PRODUCT_PROPERTY_OVERRIDES += \
    media.stagefright.legacyencoder=true \
    media.stagefright.less-secure=true

# MIDI feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:system/etc/permissions/android.software.midi.xml

#ANT+ stack
PRODUCT_PACKAGES += \
    AntHalService \
    libantradio \
    antradio_app
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    camera2.portability.force_api=1
PRODUCT_PACKAGES += wcnss_service

# MSM IRQ Balancer configuration file
PRODUCT_COPY_FILES += \
    device/wt88047_64/msm_irqbalance.conf:system/vendor/etc/msm_irqbalance.conf

#wlan driver
PRODUCT_COPY_FILES += \
    device/wt88047_64/WCNSS_qcom_cfg.ini:system/etc/wifi/WCNSS_qcom_cfg.ini \
    device/wt88047_64/WCNSS_wlan_dictionary.dat:persist/WCNSS_wlan_dictionary.dat \
    device/wt88047_64/WCNSS_qcom_wlan_nv.bin:persist/WCNSS_qcom_wlan_nv.bin

PRODUCT_PACKAGES += \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf

# Defined the locales
PRODUCT_LOCALES += th_TH vi_VN tl_PH hi_IN ar_EG ru_RU tr_TR pt_BR bn_IN mr_IN ta_IN te_IN zh_HK \
        in_ID my_MM km_KH sw_KE uk_UA pl_PL sr_RS sl_SI fa_IR kn_IN ml_IN ur_IN gu_IN or_IN zh_CN

# When can normal compile this module,  need module owner enable below commands
# Add the overlay path
PRODUCT_PACKAGE_OVERLAYS := $(QCPATH)/qrdplus/Extension/res \
        $(PRODUCT_PACKAGE_OVERLAYS)
        #$(QCPATH)/qrdplus/globalization/multi-language/res-overlay \

#PRODUCT_SUPPORTS_VERITY := true
#PRODUCT_SYSTEM_VERITY_PARTITION := /dev/block/bootdevice/by-name/system

GMS_ENABLE_OPTIONAL_MODULES := false
