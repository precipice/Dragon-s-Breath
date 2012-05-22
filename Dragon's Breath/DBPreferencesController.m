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
            launchAtLoginPreference, okayButton, cancelButton, refreshIntervalSlider,
            delegate;

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        //
    }
    
    return self;
}


- (void)loadCurrentSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL configured = [defaults boolForKey:@"configured"];
    
    NSString *username = [defaults stringForKey:@"username"];
    
    if (username != nil) {
        [self.usernameCell setStringValue:username];        
    }

    NSString *password = [HAKeychain findPasswordForService:KEYCHAIN_SERVER
                                                    account:username
                                                   keychain:NULL
                                                      error:nil];

    if (password != nil) {
        [self.passwordCell setStringValue:password];        
    }
    
    BOOL growlEnabled = [defaults boolForKey:@"growlEnabled"];
    
    if (growlEnabled || 
        (configured == NO && [GrowlApplicationBridge isGrowlRunning])) {
        [self.growlPreference setState:NSOnState];
    } else {
        [self.growlPreference setState:NSOffState];
    }

    LaunchAtLoginController *launchController = 
        [[LaunchAtLoginController alloc] init];
    BOOL launchAtLoginEnabled = [launchController launchAtLogin];
    [launchController release];
    
    if (launchAtLoginEnabled) {
        [self.launchAtLoginPreference setState:NSOnState];
    } else {
        [self.launchAtLoginPreference setState:NSOffState];
    }

    NSInteger refreshInterval = [defaults integerForKey:@"refreshInterval"];
    // look up sliderValue and set the slider
    NSInteger sliderValue = DEFAULT_REFRESH_INTERVAL_SLIDER_VALUE;
    int numValues = sizeof(REFRESH_INTERVALS) / sizeof(REFRESH_INTERVALS[0]);
    for (int i=0; i < numValues  ; i++) {
        if (REFRESH_INTERVALS[i] == refreshInterval) {
            sliderValue = SLIDER_VALUES[i];
        }
    }
    [self.refreshIntervalSlider setIntegerValue:sliderValue];
}


- (void)setupRegisterLink {
    [self.registerLink setAllowsEditingTextAttributes:YES];
    [self.registerLink setSelectable:YES];

    NSMutableAttributedString* link = 
        [[[NSMutableAttributedString alloc] init] autorelease];
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
    BOOL launchOnLoginEnabled = [self.launchAtLoginPreference state] == NSOnState;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Save the Refresh interval preference
    NSInteger sliderValue = [self.refreshIntervalSlider integerValue];
    // look up refreshInterval for the sliderValue and store it
    NSInteger refreshInterval = DEFAULT_REFRESH_INTERVAL;
    int numValues = sizeof(SLIDER_VALUES) / sizeof(SLIDER_VALUES[0]);
    for (int i=0; i < numValues  ; i++) {
        
        if ((NSInteger)SLIDER_VALUES[i] == sliderValue) {
            refreshInterval = REFRESH_INTERVALS[i];
            break;
        }
    }
    [defaults setInteger:refreshInterval forKey:@"refreshInterval"];
    
    // Save the Growl preference.
    [defaults setBool:growlEnabled forKey:@"growlEnabled"];
    
    // Save the Launch-on-Login preference.    
    LaunchAtLoginController *launchController = 
        [[LaunchAtLoginController alloc] init];
	[launchController setLaunchAtLogin:launchOnLoginEnabled];    
	[launchController release];
    
    // Save the username.
    [defaults setObject:username forKey:@"username"];
    
    // Save the password.
    NSError *error = nil;
    BOOL success = [HAKeychain createPassword:password
                                   forService:KEYCHAIN_SERVER
                                      account:username
                                     keychain:NULL
                                        error:&error];
        
    if (success == NO && [error code] == errSecDuplicateItem) {
        // Trying updating instead of creating the password.
        success = [HAKeychain updatePassword:password 
                                  forService:KEYCHAIN_SERVER 
                                     account:username 
                                    keychain:NULL 
                                       error:&error];
    }
    
    if (success == NO) {
        [self reportKeychainError:error];
    }
    
    // Note that configuration has happened, so that user settings can override
    // defaults.
    [defaults setBool:YES forKey:@"configured"];
    
    [self.delegate preferencesUpdated];
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
