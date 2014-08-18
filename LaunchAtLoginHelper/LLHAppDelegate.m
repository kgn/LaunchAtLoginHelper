//
//  LLHAppDelegate.m
//  LaunchAtLoginHelper
//
//  Created by David Keegan on 4/20/12.
//  Copyright (c) 2012 David Keegan.
//  Copyright (c) 2014 Jan Weiß.
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

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    NSString *URLScheme = [self URLScheme];
    
    // Launch the main app by opening a URL with our custom scheme
    // and `launchedAtLogin` as the host.
    // This way the main app can check how it was launched.
	NSURL *schemeURL = [[NSURL alloc] initWithScheme:URLScheme
                                                host:@"launchedAtLogin"
                                                path:@"/"];

    [[NSWorkspace sharedWorkspace] openURL:schemeURL];
    [NSApp terminate:self];
}

@end
