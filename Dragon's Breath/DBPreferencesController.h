//
//  DBPreferencesController.h
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/15/11.
//  Copyright 2011 Hack Arts, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <HAKeychain/HAKeychain.h>
#import <Growl/GrowlApplicationBridge.h>

#import "LaunchAtLoginController.h"

#import "NSAttributedString+Link.h"


#define KEYCHAIN_SERVER @"www.dragongoserver.net"
#define REGISTER_URL @"http://www.dragongoserver.net/register.php"
#define DEFAULT_REFRESH_INTERVAL_SLIDER_VALUE 12
#define DEFAULT_REFRESH_INTERVAL 5
static const int REFRESH_INTERVALS[6] = {-1, 5, 10, 15, 30, 60};
static const int SLIDER_VALUES[6]     = {0, 12, 24, 36, 48, 60};

@interface DBPreferencesController : NSWindowController <NSTextFieldDelegate> {
@private
    NSTextField *registerLink;
    NSTextFieldCell *usernameCell;
    NSSecureTextFieldCell *passwordCell;
    NSButton *growlPreference;
    NSButton *launchAtLoginPreference;
    NSButton *okayButton;
    NSButton *cancelButton;
    id delegate;
}

@property(nonatomic, retain) IBOutlet NSTextField *registerLink;
@property(nonatomic, retain) IBOutlet NSTextFieldCell *usernameCell;
@property(nonatomic, retain) IBOutlet NSSecureTextFieldCell *passwordCell;
@property(nonatomic, retain) IBOutlet NSButton *growlPreference;
@property(nonatomic, retain) IBOutlet NSButton *launchAtLoginPreference;
@property(nonatomic, retain) IBOutlet NSButton *okayButton;
@property(nonatomic, retain) IBOutlet NSButton *cancelButton;
@property(nonatomic, retain) IBOutlet NSSlider *refreshIntervalSlider;

@property(nonatomic, retain) id delegate;

- (void)loadCurrentSettings;
- (void)setupRegisterLink;
- (IBAction)okayPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
- (void)reportKeychainError:(NSError *)error;

@end

@protocol DBPreferencesDelegate

- (void)preferencesUpdated;

@end