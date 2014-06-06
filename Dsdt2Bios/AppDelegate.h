//
//  AppDelegate.h
//  Dsdt2Bios
//
//  Created by Frédéric Geoffroy on 15/04/2014.
//  Copyright (c) 2014 FredWst. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSTextView *Output;

@end
