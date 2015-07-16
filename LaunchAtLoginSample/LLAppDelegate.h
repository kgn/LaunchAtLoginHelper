//
//  LLAppDelegate.h
//  LaunchAtLoginSample
//
//  Created by David Keegan on 4/20/12.
//  Copyright (c) 2012 David Keegan.
//  Some rights reserved: <http://opensource.org/licenses/mit-license.php>
//

#import <Cocoa/Cocoa.h>

@interface LLAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSButton *checkBox;

#if 0
- (IBAction)checkBoxAction:(id)sender;
#endif

@end
