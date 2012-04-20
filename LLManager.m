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

@implementation LLManager

+ (BOOL)launchAtLogin{
    BOOL launch = NO;    
    NSArray *jobs = (NSArray *)SMCopyAllJobDictionaries(kSMDomainUserLaunchd);
    if([jobs count]){
        for(NSDictionary *job in jobs){
            if([[job objectForKey:@"Label"] isEqualToString:LLHelperBundleIdentifier]){
                launch = [[job objectForKey:@"OnDemand"] boolValue];
                break;
            }
        }
    }
#if !__has_feature(objc_arc)       
    [jobs release], jobs = nil;
#endif    
    return launch;  
}

+ (void)setLaunchAtLogin:(BOOL)value{
    if(!SMLoginItemSetEnabled((CFStringRef)LLHelperBundleIdentifier, value)){
        NSLog(@"SMLoginItemSetEnabled failed!");
    }
}

@end
