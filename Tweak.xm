#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <substrate.h>
#import "ColorFillController.h"

extern "C" UIImage * _UICreateScreenUIImage();

static BOOL enabled = NO;
static UIImage * currentScreen;
static BOOL isLowering = NO;

%hook UIWindow

-(void)setFrame:(CGRect)frame{
	%orig;
	
	if(isLowering)
	{
		NSLog(@"Deconstructing the ColorFill view and removing it from reachability.");
		[[ColorFillController sharedInstance] deconstructWidget];
		isLowering = NO;
	}
}

%end

%hook SBWorkspace

-(void)handleReachabilityModeActivated {
	currentScreen = _UICreateScreenUIImage();
	%orig;
	if (enabled && [%c(SBReachabilityManager) reachabilitySupported]) {
		NSLog(@"Setting reachability window.");
		SBWindow *backgroundView = MSHookIvar<SBWindow*>(self,"_reachabilityEffectWindow");
		[[ColorFillController sharedInstance] setWindowAndImage:backgroundView image:currentScreen];
		[[ColorFillController sharedInstance] setupWidget];
		[currentScreen release];
		currentScreen = nil;
		NSLog(@"Creation and addition success.");
	}
}

-(void)handleReachabilityModeDeactivated {
	%orig;
	isLowering = YES;
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