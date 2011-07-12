//
//  DBStatusItem.h
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DBStatusFeed.h"

@interface DBStatusItem : NSObject {
@private
    IBOutlet NSMenu *statusMenu;
    
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusHighlightImage;
    DBStatusFeed *statusFeed;
}

-(IBAction) helloWorld:(id)sender;

@end