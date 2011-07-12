//
//  DBStatusItem.h
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MWFeedParser.h"


@interface DBStatusItem : NSObject {
@private
    IBOutlet NSMenu *statusMenu;
    
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusHighlightImage;
}

-(IBAction) helloWorld:(id)sender;

@end