//
//  DBPreferencesController.m
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DBPreferencesController.h"


@implementation DBPreferencesController

@synthesize okayButton;


- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (void)windowDidLoad {
    [super windowDidLoad];
    [[self window] center];
    [NSApp activateIgnoringOtherApps:YES];
    //[[self window] setLevel:NSMainMenuWindowLevel];
    //[[self window] makeKeyAndOrderFront:self];
}


- (IBAction)okayPressed:(id)sender {
    [[self window] close];
}

- (void)dealloc {
    self.okayButton = nil;
    [super dealloc];
}


@end
