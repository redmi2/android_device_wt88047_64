$(call inherit-product, device/qcom/common/base.mk)

# For PRODUCT_COPY_FILES, the first instance takes precedence.
# Since we want use QC specific files, we should inherit
# device-vendor.mk first to make sure QC specific files gets installed.
$(call inherit-product-if-exists, $(QCPATH)/common/config/device-vendor.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from wt88047 device
$(call inherit-product, device/wt88047_64/msm8916_64.mk)

PRODUCT_NAME := caf_wt88047_64
PRODUCT_DEVICE := wt88047_64
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_MODEL := wt88047_64
PRODUCT_BRAND := Xiaomi

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

TARGET_VENDOR_PRODUCT_NAME := wt88047_64
TARGET_VENDOR_DEVICE_NAME := wt88047_64
PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_DEVICE=wt88047_64 \
    PRODUCT_NAME=wt88047_64

