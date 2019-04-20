LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := sdcard.c
LOCAL_MODULE := sdcard
LOCAL_CFLAGS := -Wall -Wno-unused-parameter -Werror -ggdb -O0 -DHAVE_LIBXML
LOCAL_SHARED_LIBRARIES := libcutils libchall libpackagelistparser
LOCAL_STRIP_MODULE := false

include $(BUILD_EXECUTABLE)
