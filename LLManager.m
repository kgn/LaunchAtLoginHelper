//
//  LLManager.m
//  LaunchAtLogin
//
//  Created by David Keegan on 4/20/12.
//  Copyright (c) 2012 David Keegan. All rights reserved.
//

#import "LLManager.h"
#import "LLStrings.h"
#import <ServiceManagement/ServiceManagement.h>


NSString * const    LLManagerSetLaunchAtLoginFailedNotification        = @"LLManagerSetLaunchAtLoginFailedNotification";


@implementation LLManager

+ (BOOL)launchAtLogin{
    BOOL launch = NO;
    CFArrayRef cfJobs = SMCopyAllJobDictionaries(kSMDomainUserLaunchd);
    if(cfJobs == NULL)  return NO;
#if __has_feature(objc_arc)
    NSArray *jobs = CFBridgingRelease(cfJobs);
#else    
    NSArray *jobs = [NSArray arrayWithArray:(NSArray *)cfJobs];
    CFRelease(cfJobs);
#endif
    if([jobs count]){
        for(NSDictionary *job in jobs){
            if([job[@"Label"] isEqualToString:LLHelperBundleIdentifier]){
                launch = [job[@"OnDemand"] boolValue];
                break;
            }
        }
    }   
    return launch;  
}

+ (void)setLaunchAtLogin:(BOOL)value {
    [self setLaunchAtLogin:value
           notifyOnFailure:NO];
}

+ (void)setLaunchAtLogin:(BOOL)value
         notifyOnFailure:(BOOL)wantFailureNotification {
#if __has_feature(objc_arc)
    if(!SMLoginItemSetEnabled((__bridge CFStringRef)LLHelperBundleIdentifier, value)){
#else
    if(!SMLoginItemSetEnabled((CFStringRef)LLHelperBundleIdentifier, value)){
#endif
        if(wantFailureNotification){
            [[NSNotificationCenter defaultCenter] postNotificationName:LLManagerSetLaunchAtLoginFailedNotification object:self];
        }
        else {
            NSLog(@"SMLoginItemSetEnabled failed!");
        }
    }
}

#pragma mark - Bindings support

- (BOOL)launchAtLogin {
    return [[self class] launchAtLogin];
}

- (void)setLaunchAtLogin:(BOOL)launchAtLogin {
    [self willChangeValueForKey:@"launchAtLogin"];
    [[self class] setLaunchAtLogin:launchAtLogin
                   notifyOnFailure:self.notifyIfSetLaunchAtLoginFailed];
    [self didChangeValueForKey:@"launchAtLogin"];
}

@end
