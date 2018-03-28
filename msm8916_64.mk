TARGET_USES_AOSP_FOR_AUDIO := true
TARGET_USES_AOSP := true
TARGET_USES_QCOM_BSP := false

TARGET_USES_HWC2 := true

#DEVICE_PACKAGE_OVERLAYS := device/wt88047_64/overlay

# Add QC Video Enhancements flag
TARGET_ENABLE_QC_AV_ENHANCEMENTS := false

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
PRODUCT_COPY_FILES += device/wt88047_64/media/media_profiles_8916.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles.xml \
                      device/wt88047_64/media/media_codecs_performance_8916_64.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
                      device/wt88047_64/media/media_codecs_8916.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml

TARGET_USES_NQ_NFC := false

PRODUCT_PROPERTY_OVERRIDES += \
           dalvik.vm.heapgrowthlimit=128m
$(call inherit-product, device/qcom/common/common64.mk)

# When can normal compile this module,  need module owner enable below commands
# font rendering engine feature switch
-include $(QCPATH)/common/config/rendering-engine.mk
ifneq (,$(strip $(wildcard $(PRODUCT_RENDERING_ENGINE_REVLIB))))
#    MULTI_LANG_ENGINE := REVERIE
#    MULTI_LANG_ZAWGYI := REVERIE
endif

# add vendor manifest file
PRODUCT_COPY_FILES += \
    device/wt88047_64/manifest.xml:$(TARGET_COPY_OUT_VENDOR)/manifest.xml

#PRODUCT_BOOT_JARS += qcom.fmradio

# QMI
PRODUCT_PACKAGES += \
    dsi_config.xml \
    netmgr_config.xml \
    qmi_config.xml

# GPS
PRODUCT_PACKAGES += \
    gps.msm8916
    
PRODUCT_COPY_FILES += \
    device/wt88047_64/configs/flp.conf:$(TARGET_COPY_OUT_VENDOR)/etc/flp.conf \
    device/wt88047_64/configs/quipc.conf:$(TARGET_COPY_OUT_VENDOR)/etc/quipc.conf \
    device/wt88047_64/configs/sap.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sap.conf

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
    device/wt88047_64/audio/acdb/QRD_Bluetooth_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/QRD/QRD_Bluetooth_cal.acdb \
    device/wt88047_64/audio/acdb/QRD_General_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/QRD/QRD_General_cal.acdb \
    device/wt88047_64/audio/acdb/QRD_Global_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/QRD/QRD_Global_cal.acdb \
    device/wt88047_64/audio/acdb/QRD_Handset_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/QRD/QRD_Handset_cal.acdb \
    device/wt88047_64/audio/acdb/QRD_Hdmi_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/QRD/QRD_Hdmi_cal.acdb \
    device/wt88047_64/audio/acdb/QRD_Headset_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/QRD/QRD_Headset_cal.acdb \
    device/wt88047_64/audio/acdb/QRD_Speaker_cal.acdb:$(TARGET_COPY_OUT_VENDOR)/etc/acdbdata/QRD/QRD_Speaker_cal.acdb \
    device/wt88047_64/audio/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    device/wt88047_64/audio/audio_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_platform_info.xml \
    device/wt88047_64/audio/audio_policy.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy.conf \
    device/wt88047_64/audio/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml \
    device/wt88047_64/audio/mixer_paths_qrd_skui.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths_qrd_skui.xml


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
    
# IMSEnabler
PRODUCT_PACKAGES += \
   IMSEnabler \
   libshim_parcel \
   libshim_boringssl \
   libshims_camera \
   libshims_ims
	
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
    frameworks/native/data/etc/android.software.midi.xml:system/vendor/etc/permissions/android.software.midi.xml

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
    device/wt88047_64/msm_irqbalance.conf:$(TARGET_COPY_OUT_VENDOR)/etc/msm_irqbalance.conf

#wlan driver
PRODUCT_COPY_FILES += \
    device/wt88047_64/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini \
    device/wt88047_64/WCNSS_wlan_dictionary.dat:persist/WCNSS_wlan_dictionary.dat \
    device/wt88047_64/WCNSS_qcom_wlan_nv.bin:persist/WCNSS_qcom_wlan_nv.bin

PRODUCT_PACKAGES += \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf

#for wlan
   PRODUCT_PACKAGES += \
       wificond \
       wifilogd

# Defined the locales
PRODUCT_LOCALES += th_TH vi_VN tl_PH hi_IN ar_EG ru_RU tr_TR pt_BR bn_IN mr_IN ta_IN te_IN zh_HK \
        in_ID my_MM km_KH sw_KE uk_UA pl_PL sr_RS sl_SI fa_IR kn_IN ml_IN ur_IN gu_IN or_IN zh_CN

# When can normal compile this module,  need module owner enable below commands
# Add the overlay path
#PRODUCT_PACKAGE_OVERLAYS := $(QCPATH)/qrdplus/Extension/res \
#        $(PRODUCT_PACKAGE_OVERLAYS)
        #$(QCPATH)/qrdplus/globalization/multi-language/res-overlay \

# Sensor HAL conf file
#PRODUCT_COPY_FILES += \
#    device/qcom/msm8916_64/sensors/hals.conf:system/etc/sensors/hals.conf
#    device/qcom/msm8916_64/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf
  
GMS_ENABLE_OPTIONAL_MODULES := false

#FEATURE_OPENGLES_EXTENSION_PACK support string config file
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:system/vendor/etc/permissions/android.hardware.opengles.aep.xml


# Display/Gralloc
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    android.hardware.light@2.0-impl \
    android.hardware.light@2.0-service \
    android.hardware.configstore@1.0-service \
    android.hardware.broadcastradio@1.0-impl

#PRODUCT_FULL_TREBLE_OVERRIDE := true

PRODUCT_VENDOR_MOVE_ENABLED := true

# Vibrator
PRODUCT_PACKAGES += \
    android.hardware.vibrator@1.0-impl \
    android.hardware.vibrator@1.0-service \

#Boot control HAL test app
PRODUCT_PACKAGES_DEBUG += bootctl

#Healthd packages
PRODUCT_PACKAGES += android.hardware.health@1.0-impl \
                    android.hardware.health@1.0-convert \
                    android.hardware.health@1.0-service \
                    libhealthd.msm
#Supports verity
PRODUCT_SUPPORTS_VERITY := false

PRODUCT_PACKAGES += \
    vendor.display.color@1.0-service

PRODUCT_PACKAGES += \
    android.hardware.audio@2.0-service \
    android.hardware.audio@2.0-impl \
    android.hardware.audio.effect@2.0-impl \
    android.hardware.soundtrigger@2.0-impl

# Power
PRODUCT_PACKAGES += \
    android.hardware.power@1.0-service \
    android.hardware.power@1.0-impl

# TARGET_DISABLE_TA_HEAP for 8916
TARGET_DISABLE_TA_HEAP := true

KMGK_USE_QTI_SERVICE := false
#Enable Google KEYMASTER and GATEKEEPER HIDLs
ifneq ($(KMGK_USE_QTI_SERVICE), true)
  PRODUCT_PACKAGES += android.hardware.gatekeeper@1.0-impl \
                      android.hardware.gatekeeper@1.0-service \
                      android.hardware.keymaster@3.0-impl \
                      android.hardware.keymaster@3.0-service
endif
