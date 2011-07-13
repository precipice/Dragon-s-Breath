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
    [statusMenu setAutoenablesItems:NO];
    [statusItem setToolTip:@"Dragon's Breath"];
    [statusItem setHighlightMode:YES];
}

- (IBAction)refresh:(id)sender {
    statusFeed = [[DBFeedParser alloc] init];
    statusFeed.delegate = self;
    [statusFeed pollFeed];
}


- (void)feedLoaded:(NSArray *)games {    
    [self clearMenu];        

    if (games == nil) {
        NSLog(@"Error while downloading feed.");
        [statusItem setImage:statusImage];
    } else if ([games count] == 0) {
        NSMenuItem *noMovesItem = [[NSMenuItem alloc] initWithTitle:NO_MOVES
                                                             action:nil 
                                                      keyEquivalent:@""];
        [noMovesItem setEnabled:NO];
        [[statusItem menu] insertItem:noMovesItem atIndex:3];
        [statusItem setImage:statusImage];
    } else {
        [games enumerateObjectsUsingBlock:^(id gameObj, NSUInteger idx, BOOL *stop) {
            DBGame *game = (DBGame *) gameObj;
                                         
            NSMenuItem *gameItem = [[NSMenuItem alloc] initWithTitle:[game details] 
                                                              action:@selector(openGame) 
                                                       keyEquivalent:@""];
            [gameItem setTarget:game];
            [gameItem setEnabled:YES];
            [[statusItem menu] insertItem:gameItem atIndex:3];
        }];
        [statusItem setImage:statusHighlightImage];
    }
}


- (void)clearMenu {
    [statusMenu removeItemAtIndex:
     [statusMenu indexOfItemWithTitle:NO_MOVES]];
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
