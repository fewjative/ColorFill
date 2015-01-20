ARCHS = armv7 arm64
include theos/makefiles/common.mk

BUNDLE_NAME = ColorFillSettings
ColorFillSettings_INSTALL_PATH = /Library/PreferenceBundles

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp ColorFillSettings.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ColorFillSettings.plist$(ECHO_END)
	$(ECHO_NOTHING)cp *.png $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/$(ECHO_END)

include $(THEOS_MAKE_PATH)/aggregate.mk
