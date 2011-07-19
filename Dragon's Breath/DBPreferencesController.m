//
//  DBPreferencesController.m
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/15/11.
//  Copyright 2011 Hack Arts, LLC. All rights reserved.
//

#import "DBPreferencesController.h"


@implementation DBPreferencesController

@synthesize usernameCell, passwordCell, registerLink, 
            okayButton, cancelButton, delegate;


- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        //
    }
    
    return self;
}


- (void)loadCurrentSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults stringForKey:@"username"];
    if (username != nil) {
        [self.usernameCell setStringValue:username];        
    }
}


- (void)setupRegisterLink {
    [self.registerLink setAllowsEditingTextAttributes:YES];
    [self.registerLink setSelectable:YES];

    NSMutableAttributedString* link = [[NSMutableAttributedString alloc] init];
    [link appendAttributedString:
     [NSAttributedString linkFromString:@"Register at DGS" 
                                withURL:REGISTER_URL]];

    [self.registerLink setAttributedStringValue:link];
}


- (void)windowDidLoad {
    [super windowDidLoad];
    [self setupRegisterLink];
    [self loadCurrentSettings];
    [[self window] center];
    [NSApp activateIgnoringOtherApps:YES];
}


- (IBAction)okayPressed:(id)sender {
    NSLog(@"Got password: %@", [self.passwordCell stringValue]);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.usernameCell stringValue] forKey:@"username"];
    
    [[self window] close];
    [self.delegate preferencesUpdated];
}


- (IBAction)cancelPressed:(id)sender {
    [[self window] close];
}


- (void)dealloc {
    self.usernameCell = nil;
    self.passwordCell = nil;
    self.registerLink = nil;
    self.okayButton = nil;
    self.cancelButton = nil;
    [super dealloc];
}


@end
