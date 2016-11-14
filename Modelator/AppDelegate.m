//
//  AppDelegate.m
//  Modelator
//
//  Created by Kostantinos Aggelopoulos on 11/11/2016.
//  Copyright © 2016 OliveSoft. All rights reserved.
//

#import "AppDelegate.h"
#import "ModuleManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [[ModuleManager sharedManager] loadModules];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

@end
