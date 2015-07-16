//
//  LLAppDelegate.m
//  LaunchAtLoginSample
//
//  Created by David Keegan on 4/20/12.
//  Copyright (c) 2012 David Keegan.
//  Some rights reserved: <http://opensource.org/licenses/mit-license.php>
//

#import "LLAppDelegate.h"
#import "LLManager.h"

@implementation LLAppDelegate

- (void)awakeFromNib{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self
						   selector:@selector(settingLaunchAtLoginFailed:)
							   name:LLManagerSetLaunchAtLoginFailedNotification
							 object:nil];
}

#if 0
// Using LLManager in code.
// This is disabled, because this sample uses an LLManager
// instantiated in the nib/xib file and bound to there.
// notifyIfSetLaunchAtLoginFailed is set there via “User Defined Runtime Attributes”.
// We could instantiate an instance here and do that all in code,
// but we don’t, because we are lazy. ;)
- (void)applicationDidFinishLaunching:(NSNotification *)notification{
    [self.checkBox setState:[LLManager launchAtLogin]];
}

- (IBAction)checkBoxAction:(id)sender{
    [LLManager setLaunchAtLogin:[sender state]];
}
#endif

- (void)settingLaunchAtLoginFailed:(NSNotification *)notification{
	NSAlert *alert = nil;
	
	NSDictionary *localizedInfoDictionary = [[NSBundle mainBundle] localizedInfoDictionary];
	
	NSString *displayName = [localizedInfoDictionary objectForKey:@"CFBundleDisplayName"];
	if (displayName == nil)  displayName = [[NSRunningApplication currentApplication] localizedName];
	
	NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Could not change the setting for opening “%@” at Login.", @"Notify of launch at login setting change failure."), displayName];
	NSString *details = NSLocalizedString(@"Your version of OS X may not be supported, yet. \n"
										  "Alternatively, you may not have the required permissions to change the setting or the app may be damaged.", @"Notify of launch at login setting change failure (details).");
	alert = [NSAlert alertWithMessageText:message
							defaultButton:nil // Default: OK
						  alternateButton:nil
							  otherButton:nil
				informativeTextWithFormat:details, nil];
	
	[alert runModal];
}

@end
