#import <substrate.h>
#import "InstagramHeaders.h"
#import "Tweak.h"
#import "Utils.h"
#import "Manager.h"
#import "Download.h"

#import "Controllers/SecurityViewController.h"
#import "Controllers/SettingsViewController.h"

// Variables that work across features
BOOL seenButtonEnabled = false;
BOOL dmVisualMsgsViewedButtonEnabled = false;

// Tweak first-time setup
%hook IGInstagramAppDelegate
- (_Bool)application:(UIApplication *)application didFinishLaunchingWithOptions:(id)arg2 {
    %orig;

    // Set default config values
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"BHInstaFirstRun"] == nil) {
        [[NSUserDefaults standardUserDefaults] setValue:@"BHInstaFirstRun" forKey:@"BHInstaFirstRun"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"hide_ads"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"dw_videos"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"save_profile"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"remove_screenshot_alert"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"show_like_count"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"copy_description"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"keep_deleted_message"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"call_confirm"];

        // Display settings modal on screen
        UIViewController *rootController = [[self window] rootViewController];
        SettingsViewController *settingsViewController = [SettingsViewController new];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
        
        [rootController presentViewController:navigationController animated:YES completion:nil];
    }
    [BHIManager cleanCache];

    return true;
}

// Biometric/passcode authentication
static BOOL isAuthenticationShowed = FALSE;

- (void)applicationDidBecomeActive:(id)arg1 {
    %orig;

    // Show FLEX when application becomes active
    if ([BHIManager FLEX]) {
        [[objc_getClass("FLEXManager") sharedManager] showExplorer];
    }

    // Padlock (biometric auth)
    if ([BHIManager Padlock] && !isAuthenticationShowed) {
        UIViewController *rootController = [[self window] rootViewController];
        SecurityViewController *securityViewController = [SecurityViewController new];
        securityViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [rootController presentViewController:securityViewController animated:YES completion:nil];
        isAuthenticationShowed = TRUE;
    }
}

- (void)applicationWillEnterForeground:(id)arg1 {
    %orig;

    // Reset padlock status
    isAuthenticationShowed = FALSE;
}
%end


// Instagram DM visual messages
%hook IGDirectVisualMessageViewerSession
- (id)visualMessageViewerController:(id)arg1 didDetectScreenshotForVisualMessage:(id)arg2 atIndex:(NSInteger)arg3 {
    if ([BHIManager noScreenShotAlert]) {
        return nil;
    }
    return %orig;
}

- (id)visualMessageViewerController:(id)arg1 didEndPlaybackForVisualMessage:(id)arg2 atIndex:(NSInteger)arg3 forNavType:(NSInteger)arg4 {
    if ([BHIManager unlimitedReplay]) {
        return nil;
    }
    return %orig;
}
%end
%hook IGDirectVisualMessageReplayService
- (id)visualMessageViewerController:(id)arg1 didDetectScreenshotForVisualMessage:(id)arg2 atIndex:(NSInteger)arg3 {
    if ([BHIManager noScreenShotAlert]) {
        return nil;
    }
    return %orig;
}

- (id)visualMessageViewerController:(id)arg1 didEndPlaybackForVisualMessage:(id)arg2 atIndex:(NSInteger)arg3 forNavType:(NSInteger)arg4 {
    if ([BHIManager unlimitedReplay]) {
        return nil;
    }
    return %orig;
}
%end
%hook IGDirectVisualMessageReportService
- (id)visualMessageViewerController:(id)arg1 didDetectScreenshotForVisualMessage:(id)arg2 atIndex:(NSInteger)arg3 {
    if ([BHIManager noScreenShotAlert]) {
        return nil;
    }
    return %orig;
}

- (id)visualMessageViewerController:(id)arg1 didEndPlaybackForVisualMessage:(id)arg2 atIndex:(NSInteger)arg3 forNavType:(NSInteger)arg4 {
    if ([BHIManager unlimitedReplay]) {
        return nil;
    }
    return %orig;
}
%end


//////////

%hook HBForceCepheiPrefs
+ (BOOL)forceCepheiPrefsWhichIReallyNeedToAccessAndIKnowWhatImDoingISwear {
    return YES;
}
%end