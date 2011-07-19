//
//  DBPreferencesController.h
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/15/11.
//  Copyright 2011 Hack Arts, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSAttributedString+Link.h"

#define REGISTER_URL @"http://www.dragongoserver.net/register.php"

@interface DBPreferencesController : NSWindowController <NSTextFieldDelegate> {
@private
    NSTextFieldCell *usernameCell;
    NSSecureTextFieldCell *passwordCell;
    NSTextField *registerLink;
    NSButton *okayButton;
    NSButton *cancelButton;
    id delegate;
}

@property(nonatomic, retain) IBOutlet NSTextFieldCell *usernameCell;
@property(nonatomic, retain) IBOutlet NSSecureTextFieldCell *passwordCell;
@property(nonatomic, retain) IBOutlet NSTextField *registerLink;
@property(nonatomic, retain) IBOutlet NSButton *okayButton;
@property(nonatomic, retain) IBOutlet NSButton *cancelButton;
@property(nonatomic, retain) id delegate;

- (void)loadCurrentSettings;
- (void)setupRegisterLink;
- (IBAction)okayPressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;

@end

@protocol DBPreferencesDelegate

- (void)preferencesUpdated;

@end