//
//  DBPreferencesController.m
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DBPreferencesController.h"


@implementation DBPreferencesController

@synthesize usernameCell, passwordCell, okayButton;


- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        // initialization
    }
    
    return self;
}


- (void)windowDidLoad {
    [super windowDidLoad];
    [[self window] center];
    [NSApp activateIgnoringOtherApps:YES];
}


- (IBAction)okayPressed:(id)sender {
    NSLog(@"Got username: %@", [self.usernameCell stringValue]);
    NSLog(@"Got password: %@", [self.passwordCell stringValue]);
    [[self window] close];
}

- (void)dealloc {
    self.okayButton = nil;
    [super dealloc];
}


@end
