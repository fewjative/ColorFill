#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <substrate.h>
#import "ColorFillController.h"

extern "C" UIImage * _UICreateScreenUIImage();

static BOOL enabled = NO;
static UIImage * currentScreen;
static BOOL isLowering = NO;

// for iOS9
%hook SBMainWorkspace

-(void)handleReachabilityModeActivated {
	currentScreen = _UICreateScreenUIImage();
	%orig;
	if (enabled && [%c(SBReachabilityManager) reachabilitySupported]) {
		NSLog(@"[ColorFill] Setting reachability window.");
		SBWindow *backgroundView = MSHookIvar<SBWindow*>(self,"_reachabilityEffectWindow");
		[[ColorFillController sharedInstance] setWindowAndImage:backgroundView image:currentScreen];
		[[ColorFillController sharedInstance] setupWidget];
		[currentScreen release];
		currentScreen = nil;
		NSLog(@"[ColorFill] Creation and addition success.");
	}
}

-(void)handleReachabilityModeDeactivated {
	%orig;

	int64_t delay = 1.0;
	dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
	dispatch_after(time, dispatch_get_main_queue(), ^(void) {
			[[ColorFillController sharedInstance] deconstructWidget];
	});

}

-(void)handleCancelReachabilityRecognizer:(id)arg{
	%orig;

	int64_t delay = 1.0;
	dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
	dispatch_after(time, dispatch_get_main_queue(), ^(void) {
			[[ColorFillController sharedInstance] deconstructWidget];
	});
}

%end

%hook SBWorkspace

-(void)handleReachabilityModeActivated {
	currentScreen = _UICreateScreenUIImage();
	%orig;
	if (enabled && [%c(SBReachabilityManager) reachabilitySupported]) {
		NSLog(@"[ColorFill] Setting reachability window.");
		SBWindow *backgroundView = MSHookIvar<SBWindow*>(self,"_reachabilityEffectWindow");
		[[ColorFillController sharedInstance] setWindowAndImage:backgroundView image:currentScreen];
		[[ColorFillController sharedInstance] setupWidget];
		[currentScreen release];
		currentScreen = nil;
		NSLog(@"[ColorFill] Creation and addition success.");
	}
}

-(void)handleReachabilityModeDeactivated {
	%orig;

	int64_t delay = 1.0;
	dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
	dispatch_after(time, dispatch_get_main_queue(), ^(void) {
			[[ColorFillController sharedInstance] deconstructWidget];
	});
}

-(void)handleCancelReachabilityRecognizer:(id)arg{
	%orig;

	int64_t delay = 1.0;
	dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
	dispatch_after(time, dispatch_get_main_queue(), ^(void) {
			[[ColorFillController sharedInstance] deconstructWidget];
	});
}

%end

static void loadPrefs() 
{
	NSLog(@"Loading ColorFill prefs");
    CFPreferencesAppSynchronize(CFSTR("com.joshdoctors.colorfill"));

    enabled = !CFPreferencesCopyAppValue(CFSTR("enabled"), CFSTR("com.joshdoctors.colorfill")) ? NO : [(id)CFPreferencesCopyAppValue(CFSTR("enabled"), CFSTR("com.joshdoctors.colorfill")) boolValue];
    if (enabled) {
        NSLog(@"[ColorFill] We are enabled");
    } else {
        NSLog(@"[ColorFill] We are NOT enabled");
    }
}

%ctor
{
	NSLog(@"Loading ColorFill");
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                NULL,
                                (CFNotificationCallback)loadPrefs,
                                CFSTR("com.joshdoctors.colorfill/settingschanged"),
                                NULL,
                                CFNotificationSuspensionBehaviorDeliverImmediately);
	loadPrefs();
}