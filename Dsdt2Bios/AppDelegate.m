//
//  AppDelegate.m
//  Dsdt2Bios
//
//  Created by Frédéric Geoffroy on 15/04/2014.
//  Copyright (c) 2014 FredWst. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.Output.string=@"\n\n\n\n\n\nYOU MUST DRAG AND DROP SIMULTANEOUSLY\n\nYOUR ORIGINAL AMIBOARDINFO AND YOUR NEW DSDT \n\nOR\n\nJUST DRAG AND DROP AMIBOARDINFO TO GET ORIGINAL DSDT";

}
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication{

    return YES;
}

@end
