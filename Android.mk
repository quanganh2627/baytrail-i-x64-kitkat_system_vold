LOCAL_PATH:= $(call my-dir)

common_src_files := \
	VolumeManager.cpp \
	CommandListener.cpp \
	VoldCommand.cpp \
	NetlinkManager.cpp \
	NetlinkHandler.cpp \
	Volume.cpp \
	DirectVolume.cpp \
	Process.cpp \
	Ext4.cpp \
	Fat.cpp \
	Loop.cpp \
	Devmapper.cpp \
	ResponseCode.cpp \
	Xwarp.cpp \
	VoldUtil.c \
	fstrim.c \
	cryptfs.c

common_c_includes := \
	$(KERNEL_HEADERS) \
	system/extras/ext4_utils \
	external/openssl/include \
	external/stlport/stlport \
	bionic \
	external/scrypt/lib/crypto

common_shared_libraries := \
	libsysutils \
	libstlport \
	libcutils \
	liblog \
	libdiskconfig \
	libhardware_legacy \
	liblogwrap \
	libext4_utils \
	libcrypto

common_static_libraries := \
	libfs_mgr \
	libscrypt_static \
	libmincrypt

#ARKHAM-952: add ess command to vold that
#uses ecryptfs for container encryption
ifeq ($(strip $(INTEL_FEATURE_ARKHAM)),true)
ESS_LOCAL_PATH := vendor/intel/PRIVATE/arkham/aosp/system/vold
common_src_files += \
	../../$(ESS_LOCAL_PATH)/ess.c \
	../../$(ESS_LOCAL_PATH)/EssCmd.cpp
common_c_includes += \
	$(ESS_LOCAL_PATH)
ifeq ($(strip $(INTEL_FEATURE_ARKHAM_CHAABI)),true)
CC54_LOCAL_PATH := vendor/intel/hardware/cc54/libcc54
common_c_includes += \
        $(CC54_LOCAL_PATH)/include/export
endif
endif

include $(CLEAR_VARS)

LOCAL_MODULE := libvold

LOCAL_SRC_FILES := $(common_src_files)

LOCAL_C_INCLUDES := $(common_c_includes)

LOCAL_SHARED_LIBRARIES := $(common_shared_libraries)

LOCAL_STATIC_LIBRARIES := $(common_static_libraries)

LOCAL_MODULE_TAGS := eng tests

ifeq ($(strip $(INTEL_FEATURE_ARKHAM)),true)
LOCAL_CFLAGS += -DINTEL_FEATURE_ARKHAM
ifeq ($(strip $(INTEL_FEATURE_ARKHAM_CHAABI)),true)
LOCAL_CFLAGS += -DINTEL_FEATURE_ARKHAM_CHAABI
LOCAL_STATIC_LIBRARIES += libdx_cc7_static
endif
endif

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE:= vold

LOCAL_SRC_FILES := \
	main.cpp \
	$(common_src_files)

LOCAL_C_INCLUDES := $(common_c_includes)

LOCAL_CFLAGS := -Werror=format

LOCAL_SHARED_LIBRARIES := $(common_shared_libraries)

LOCAL_STATIC_LIBRARIES := $(common_static_libraries)

ifeq ($(strip $(INTEL_FEATURE_ARKHAM)),true)
LOCAL_CFLAGS += -DINTEL_FEATURE_ARKHAM
ifeq ($(strip $(INTEL_FEATURE_ARKHAM_CHAABI)),true)
LOCAL_CFLAGS += -DINTEL_FEATURE_ARKHAM_CHAABI
LOCAL_SHARED_LIBRARIES += libdx_cc7
endif
endif

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= vdc.c

LOCAL_MODULE:= vdc

LOCAL_C_INCLUDES := $(KERNEL_HEADERS)

LOCAL_CFLAGS := 

LOCAL_SHARED_LIBRARIES := libcutils

include $(BUILD_EXECUTABLE)
