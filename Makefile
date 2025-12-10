TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = ChatdiIOS
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = UnlockChatdi

UnlockChatdi_FILES = \
			Tweak.xm \
			Hooks/RNCAsyncStorageHooks.xm \
			Hooks/FFFastImageViewHooks.xm

UnlockChatdi_CFLAGS = -fobjc-arc
UnlockChatdi_CFLAGS += -F./layout/Library/Frameworks
UnlockChatdi_LDFLAGS += -F./layout/Library/Frameworks -framework MobileVLCKit

include $(THEOS_MAKE_PATH)/tweak.mk
