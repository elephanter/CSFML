LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := csfml-system
LOCAL_SRC_FILES := lib/$(TARGET_ARCH_ABI)/libcsfml-system.so
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include

prebuilt_path := $(call local-prebuilt-path,$(LOCAL_SRC_FILES))
prebuilt := $(strip $(wildcard $(prebuilt_path)))

ifdef prebuilt
    include $(PREBUILT_SHARED_LIBRARY)
endif

include $(CLEAR_VARS)
LOCAL_MODULE := csfml-window
LOCAL_SRC_FILES := lib/$(TARGET_ARCH_ABI)/libcsfml-window.so
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include
LOCAL_EXPORT_LDLIBS := -lEGL -llog -landroid
LOCAL_SHARED_LIBRARIES := csfml-system

prebuilt_path := $(call local-prebuilt-path,$(LOCAL_SRC_FILES))
prebuilt := $(strip $(wildcard $(prebuilt_path)))

ifdef prebuilt
    include $(PREBUILT_SHARED_LIBRARY)
endif
include $(CLEAR_VARS)
LOCAL_MODULE := csfml-graphics
LOCAL_SRC_FILES := lib/$(TARGET_ARCH_ABI)/libcsfml-graphics.so
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include
LOCAL_SHARED_LIBRARIES += csfml-system csfml-window

prebuilt_path := $(call local-prebuilt-path,$(LOCAL_SRC_FILES))
prebuilt := $(strip $(wildcard $(prebuilt_path)))

ifdef prebuilt
    include $(PREBUILT_SHARED_LIBRARY)
endif

include $(CLEAR_VARS)
LOCAL_MODULE := csfml-audio
LOCAL_SRC_FILES := lib/$(TARGET_ARCH_ABI)/libcsfml-audio.so
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include
LOCAL_SHARED_LIBRARIES := csfml-window csfml-system

prebuilt_path := $(call local-prebuilt-path,$(LOCAL_SRC_FILES))
prebuilt := $(strip $(wildcard $(prebuilt_path)))

ifdef prebuilt
    include $(PREBUILT_SHARED_LIBRARY)
endif

include $(CLEAR_VARS)
LOCAL_MODULE := csfml-network
LOCAL_SRC_FILES := lib/$(TARGET_ARCH_ABI)/libcsfml-network.so
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include
LOCAL_SHARED_LIBRARIES := csfml-system

prebuilt_path := $(call local-prebuilt-path,$(LOCAL_SRC_FILES))
prebuilt := $(strip $(wildcard $(prebuilt_path)))

ifdef prebuilt
    include $(PREBUILT_SHARED_LIBRARY)
endif

include $(CLEAR_VARS)
LOCAL_MODULE := csfml-system-d
LOCAL_SRC_FILES := lib/$(TARGET_ARCH_ABI)/libcsfml-system-d.so
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include

prebuilt_path := $(call local-prebuilt-path,$(LOCAL_SRC_FILES))
prebuilt := $(strip $(wildcard $(prebuilt_path)))

ifdef prebuilt
    include $(PREBUILT_SHARED_LIBRARY)
endif

include $(CLEAR_VARS)
LOCAL_MODULE := csfml-window-d
LOCAL_SRC_FILES := lib/$(TARGET_ARCH_ABI)/libcsfml-window-d.so
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include
LOCAL_EXPORT_LDLIBS := -lEGL -llog -landroid
LOCAL_SHARED_LIBRARIES := csfml-system-d

prebuilt_path := $(call local-prebuilt-path,$(LOCAL_SRC_FILES))
prebuilt := $(strip $(wildcard $(prebuilt_path)))

ifdef prebuilt
    include $(PREBUILT_SHARED_LIBRARY)
endif

include $(CLEAR_VARS)
LOCAL_MODULE := csfml-graphics-d
LOCAL_SRC_FILES := lib/$(TARGET_ARCH_ABI)/libcsfml-graphics-d.so
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include
LOCAL_SHARED_LIBRARIES += csfml-system-d csfml-window-d

prebuilt_path := $(call local-prebuilt-path,$(LOCAL_SRC_FILES))
prebuilt := $(strip $(wildcard $(prebuilt_path)))

ifdef prebuilt
    include $(PREBUILT_SHARED_LIBRARY)
endif

include $(CLEAR_VARS)
LOCAL_MODULE := csfml-audio-d
LOCAL_SRC_FILES := lib/$(TARGET_ARCH_ABI)/libcsfml-audio-d.so
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include
LOCAL_SHARED_LIBRARIES := csfml-window-d csfml-system-d

prebuilt_path := $(call local-prebuilt-path,$(LOCAL_SRC_FILES))
prebuilt := $(strip $(wildcard $(prebuilt_path)))

ifdef prebuilt
    include $(PREBUILT_SHARED_LIBRARY)
endif

include $(CLEAR_VARS)
LOCAL_MODULE := csfml-network-d
LOCAL_SRC_FILES := lib/$(TARGET_ARCH_ABI)/libcsfml-network-d.so
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include
LOCAL_SHARED_LIBRARIES := csfml-system-d

prebuilt_path := $(call local-prebuilt-path,$(LOCAL_SRC_FILES))
prebuilt := $(strip $(wildcard $(prebuilt_path)))

ifdef prebuilt
    include $(PREBUILT_SHARED_LIBRARY)
endif
