//
//  DBStatusItem.m
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/12/11.
//  Copyright 2011 Hack Arts, Inc. All rights reserved.
//

#import "DBStatusMenu.h"

@implementation DBStatusMenu

- (void)awakeFromNib {
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
    statusImage = [NSImage imageNamed:@"disabled-icon.png"];
    statusHighlightImage = [NSImage imageNamed:@"black-icon.png"];
    
    [statusItem setImage:statusImage];
    [statusItem setAlternateImage:statusHighlightImage];
    
    [statusItem setMenu:statusMenu];
    [statusMenu setAutoenablesItems:NO];
    
    [self refresh:nil];
    
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:300.0
                                                    target:self
                                                  selector:@selector(refresh:)
                                                  userInfo:nil
                                                   repeats:YES];
    [refreshTimer retain];

    // Listen for events when the computer wakes from sleep, which otherwise
    // throws off the refresh schedule.
    [[[NSWorkspace sharedWorkspace] 
      notificationCenter] addObserver:self 
                             selector:@selector(receiveWakeNote:) 
                                 name:NSWorkspaceDidWakeNotification 
                               object:nil];

}


- (void)receiveWakeNote:(NSNotification*)note {
    NSLog(@"Scheduling wake-up refresh 10 seconds from now.");
    // Wait a bit after wake before refreshing, so we don't make wake slower.
    [NSTimer scheduledTimerWithTimeInterval:10.0
                                     target:self
                                   selector:@selector(refresh:)
                                   userInfo:nil
                                    repeats:NO];
}


- (IBAction)refresh:(id)sender {
    NSLog(@"Refreshing feed.");
    statusFeed = [[DBFeedParser alloc] init];
    statusFeed.delegate = self;
    [statusFeed pollFeed];
}


- (void)feedLoaded:(NSArray *)games {    
    [self clearMenu];        

    if (games == nil) {
        [statusItem setImage:statusImage];
        [statusItem setToolTip:@"Error downloading feed"];
        
    } else if ([games count] == 0) {
        NSMenuItem *noMovesItem = [[NSMenuItem alloc] initWithTitle:NO_MOVES
                                                             action:nil 
                                                      keyEquivalent:@""];
        [noMovesItem setEnabled:NO];
        [[statusItem menu] insertItem:noMovesItem atIndex:3];
        [statusItem setImage:statusImage];
        [statusItem setToolTip:@"No moves waiting"];

    } else {
        insertionIndex = 3;
        [games enumerateObjectsUsingBlock:^(id gameObj, NSUInteger idx, BOOL *stop) {
            DBGame *game = (DBGame *) gameObj;
            game.statusItem = self;
            NSMenuItem *gameItem = [[NSMenuItem alloc] initWithTitle:[game details] 
                                                              action:@selector(openGame) 
                                                       keyEquivalent:@""];
            [gameItem setTarget:game];
            [gameItem setEnabled:YES];
            [[statusItem menu] insertItem:gameItem atIndex:insertionIndex];
            insertionIndex = insertionIndex + 1;
        }];
        [statusItem setImage:statusHighlightImage];
        [statusItem setToolTip:[NSString stringWithFormat:@"%d moves waiting", 
                                                          [games count]]];
    }
}


- (void)clearMenu {
    NSArray *menuItems = [statusMenu itemArray];
    [menuItems enumerateObjectsUsingBlock:^(id itemObj, NSUInteger idx, BOOL *stop) {
        NSMenuItem *item = (NSMenuItem *) itemObj;
        if ([[item title] isEqualToString:NO_MOVES] ||
            [item action] == @selector(openGame)) {
            [statusMenu removeItem:item];
        }
    }];
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
    [[[NSWorkspace sharedWorkspace] 
      notificationCenter] removeObserver:self 
                                    name:NSWorkspaceDidWakeNotification 
                                  object:nil];

    [refreshTimer invalidate];
    [refreshTimer release];
    [statusImage release];
    [statusHighlightImage release];
    [statusFeed release];
    
    [super dealloc];
}


@end
