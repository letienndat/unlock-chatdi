TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = ChatdiIOS
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = UnlockChatdi

UnlockChatdi_FILES = \
			Tweak.xm \
			Hooks/RNCAsyncStorageHooks.xm

UnlockChatdi_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
