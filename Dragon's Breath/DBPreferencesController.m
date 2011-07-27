//
//  DBPreferencesController.m
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/15/11.
//  Copyright 2011 Hack Arts, LLC. All rights reserved.
//

#import "DBPreferencesController.h"


@implementation DBPreferencesController

@synthesize registerLink, usernameCell, passwordCell, growlPreference,
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
    NSString *username = [self.usernameCell stringValue];
    NSString *password = [self.passwordCell stringValue];
    BOOL growlEnabled  = [self.growlPreference state] == NSOnState;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Save the Growl preference.
    [defaults setBool:growlEnabled forKey:@"growlEnabled"];
    
    // Save the username.
    [defaults setObject:username forKey:@"username"];

    NSLog(@"Trying to save to keychain: account: %@, service: %@, password: %@",
          username, KEYCHAIN_SERVER, password);
    
    // Save the password.
    NSError *error = nil;
    BOOL success = [HAKeychain createPassword:password
                                   forService:KEYCHAIN_SERVER
                                      account:username
                                     keychain:NULL
                                        error:&error];
        
    if (success) {
        [self.delegate preferencesUpdated];
    } else {    
        [self reportKeychainError:error];
    }

    [[self window] close];
}


- (IBAction)cancelPressed:(id)sender {
    [[self window] close];
}


- (void)reportKeychainError:(NSError *)error {
    NSAlert *alert = 
    [NSAlert alertWithMessageText:@"Password save failed"
                    defaultButton:@"OK" 
                  alternateButton:nil
                      otherButton:nil 
        informativeTextWithFormat:@"There was a problem saving the password: "
                                   "%@", [error localizedDescription]];
    [alert runModal];
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
