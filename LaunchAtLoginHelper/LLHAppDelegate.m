//
//  LLHAppDelegate.m
//  LaunchAtLoginHelper
//
//  Created by David Keegan on 4/20/12.
//  Copyright (c) 2012 David Keegan. All rights reserved.
//

#import "LLHAppDelegate.h"
#import "LLStrings.h"

@implementation LLHAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification{
    NSString *scheme = [NSString stringWithFormat:@"%@://", LLURLScheme];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:scheme]];
    [NSApp terminate:self];
}

@end
