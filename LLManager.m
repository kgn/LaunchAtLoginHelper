//
//  LLManager.m
//  LaunchAtLogin
//
//  Created by David Keegan on 4/20/12.
//  Copyright (c) 2012 David Keegan.
//  Copyright (c) 2014 Jan Weiß.
//  Some rights reserved: <http://opensource.org/licenses/mit-license.php>
//

#import "LLManager.h"
#import <ServiceManagement/ServiceManagement.h>


NSString * const    LLManagerSetLaunchAtLoginFailedNotification        = @"LLManagerSetLaunchAtLoginFailedNotification";


@implementation LLManager

+ (NSString *)helperBundleIdentifier {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSString *helperBundleIdentifier = infoDictionary[@"LLHelperBundleIdentifier"];
    if(helperBundleIdentifier == nil)  NSLog(@"LLHelperBundleIdentifier not set in “Info.plist”!");
    return helperBundleIdentifier;
}

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
    
    NSString *helperBundleIdentifier = [self helperBundleIdentifier];

    if([jobs count]){
        for(NSDictionary *job in jobs){
            if([job[@"Label"] isEqualToString:helperBundleIdentifier]){
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
    NSString *helperBundleIdentifier = [self helperBundleIdentifier];
#if __has_feature(objc_arc)
    CFStringRef LLHelperBundleIdentifierCF = (__bridge CFStringRef)helperBundleIdentifier;
#else
    CFStringRef LLHelperBundleIdentifierCF = (CFStringRef)helperBundleIdentifier;
#endif
    
    if(!SMLoginItemSetEnabled(LLHelperBundleIdentifierCF, value)){
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
