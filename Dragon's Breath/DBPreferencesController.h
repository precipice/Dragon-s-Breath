//
//  DBPreferencesController.h
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DBPreferencesController : NSWindowController {
@private
    NSButton *okayButton;
}

@property(nonatomic, retain) IBOutlet NSButton *okayButton;

- (IBAction)okayPressed:(id)sender;

@end
