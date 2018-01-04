//
//  AppDelegate.m
//  FFResign
//
//  Created by 燚 on 2018/1/4.
//  Copyright © 2018年 Interesting. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)hasVisibleWindows {
    for (NSWindow *window in sender.windows) {
        if ([window isMemberOfClass:NSWindow.class]) {
            [window setIsVisible:YES];
            [window makeKeyAndOrderFront:self];
        }
    }
    return YES;
}


@end
