//
//  DBStatusItem.m
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DBStatusItem.h"


@implementation DBStatusItem

-(void) awakeFromNib {
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
    statusImage = [NSImage imageNamed:@"disabled-icon.png"];
    statusHighlightImage = [NSImage imageNamed:@"black-icon.png"];
    
    [statusItem setImage:statusImage];
    [statusItem setAlternateImage:statusHighlightImage];
    
    [statusItem setMenu:statusMenu];
    [statusItem setToolTip:@"Dragon's Breath"];
    [statusItem setHighlightMode:YES];
}

-(void) dealloc {
    [statusImage release];
    [statusHighlightImage release];
    [super dealloc];
}

-(IBAction) helloWorld:(id)sender {
    [statusItem setImage:statusHighlightImage];
}

@end
