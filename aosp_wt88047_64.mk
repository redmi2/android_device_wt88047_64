#
# Copyright 2017 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

$(call inherit-product, device/wt88047_64/base.mk)

# For PRODUCT_COPY_FILES, the first instance takes precedence.
# Since we want use QC specific files, we should inherit
# device-vendor.mk first to make sure QC specific files gets installed.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from wt88047 device
$(call inherit-product, device/wt88047_64/msm8916_64.mk)

PRODUCT_NAME := aosp_wt88047_64
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

PRODUCT_PACKAGES += \
    Launcher3
