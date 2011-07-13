//
//  DBStatusItem.m
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DBStatusItem.h"


@implementation DBStatusItem

- (void)awakeFromNib {
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
    statusImage = [NSImage imageNamed:@"disabled-icon.png"];
    statusHighlightImage = [NSImage imageNamed:@"black-icon.png"];
    
    [statusItem setImage:statusImage];
    [statusItem setAlternateImage:statusHighlightImage];
    
    [statusItem setMenu:statusMenu];
    [statusItem setToolTip:@"Dragon's Breath"];
    [statusItem setHighlightMode:YES];
}

- (IBAction)refresh:(id)sender {
    [statusItem setImage:statusHighlightImage];
    statusFeed = [[DBStatusFeed alloc] init];
    [statusFeed pollFeed];
}


- (IBAction)openStatus:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:STATUS_URL]];
}


- (IBAction)openRunningGames:(id)sender {
    NSString *urlString = [NSString stringWithFormat:@"%@?%@", RUNNING_GAMES_URL, DRAGON_USERID];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlString]];
}


- (IBAction)openWaitingRoom:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:WAITING_ROOM_URL]];
}


- (void)dealloc {
    [statusImage release];
    [statusHighlightImage release];
    [statusFeed release];
    
    [super dealloc];
}


@end
