//
//  LLHAppDelegate.m
//  LaunchAtLoginHelper
//
//  Created by David Keegan on 4/20/12.
//  Copyright (c) 2012 David Keegan.
//  Some rights reserved: <http://opensource.org/licenses/mit-license.php>
//

#import "LLHAppDelegate.h"

@implementation LLHAppDelegate

- (NSString *)URLScheme {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSString *URLScheme = infoDictionary[@"LLURLScheme"];
    if(URLScheme == nil)  NSLog(@"LLURLScheme not set in “Info.plist”!");
    return URLScheme;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification{
    NSString *URLScheme = [self URLScheme];
    
    // Call the scheme to launch the app
    NSString *scheme = [NSString stringWithFormat:@"%@://", URLScheme];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:scheme]];
    
    // Call the app again this time with `launchedAtLogin` so it knows how it was launched
    NSString *schemeLaunchedAtLogin = 
    [NSString stringWithFormat:@"%@://launchedAtLogin", URLScheme];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:schemeLaunchedAtLogin]];    
    [NSApp terminate:self];
}

@end
