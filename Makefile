ARCHS = armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = ColorFill
ColorFill_FILES = Tweak.xm ColorFillController.m
ColorFill_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore
ColorFill_CFLAGS = -Wno-error
ColorFill_LDFLAGS += -Wl,-segalign,4000
export GO_EASY_ON_ME := 1
include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += ColorFillSettings
include $(THEOS_MAKE_PATH)/aggregate.mk

before-stage::
	find . -name ".DS_STORE" -delete
after-install::
	install.exec "killall -9 backboardd"
