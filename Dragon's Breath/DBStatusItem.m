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
    [statusItem setImage:statusHighlightImage];
    statusFeed = [[DBFeedParser alloc] init];
    statusFeed.delegate = self;
    [statusFeed pollFeed];
}


- (void)feedLoaded:(NSArray *)games {    
    [self clearMenu];        

    if (games == nil) {
        NSLog(@"Error while downloading feed.");
    } else if ([games count] == 0) {
        NSMenuItem *noMovesItem = [[NSMenuItem alloc] initWithTitle:@"No Moves Waiting" 
                                                             action:nil 
                                                      keyEquivalent:@""];
        [noMovesItem setEnabled:NO];
        [[statusItem menu] insertItem:noMovesItem atIndex:3];        
    } else {
        [games enumerateObjectsUsingBlock:^(id game, NSUInteger idx, BOOL *stop) {
            NSDictionary *gameFields = (NSDictionary *) game;
            NSString *gameDescription = [NSString stringWithFormat:@"%@ (%@): %@ - %@", 
                                         [gameFields valueForKey:@"opponent_name"],
                                         [gameFields valueForKey:@"opponent_handle"],
                                         [gameFields valueForKey:@"color"],
                                         [gameFields valueForKey:@"move"]];
                                         
            NSMenuItem *gameItem = [[NSMenuItem alloc] initWithTitle:gameDescription 
                                                              action:@selector(openGame) 
                                                       keyEquivalent:@""];
            [gameItem setEnabled:YES];
            [[statusItem menu] insertItem:gameItem atIndex:3];
        }];
    }
}


- (void)clearMenu {
    [statusMenu removeItemAtIndex:
     [statusMenu indexOfItemWithTitle:@"No Moves Waiting"]];
}


- (void)openGame {
    NSLog(@"Got openGame");
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
