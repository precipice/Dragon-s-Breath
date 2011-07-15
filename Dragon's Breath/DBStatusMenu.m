//
//  DBStatusItem.m
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/12/11.
//  Copyright 2011 Hack Arts, Inc. All rights reserved.
//

#import "DBStatusMenu.h"

@implementation DBStatusMenu

@synthesize currentGames;

- (void)awakeFromNib {
    statusItem = [[[NSStatusBar systemStatusBar] 
                   statusItemWithLength:NSSquareStatusItemLength] retain];
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
    // Kill off the current refresh schedule.
    [refreshTimer invalidate];
    [refreshTimer release];
    
    // Wait a bit after wake before refreshing, so we don't make wake slower.
    [NSTimer scheduledTimerWithTimeInterval:10.0
                                     target:self
                                   selector:@selector(refresh:)
                                   userInfo:nil
                                    repeats:NO];
    
    // Reset the refresh schedule after the wake refresh.
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:310.0
                                                    target:self
                                                  selector:@selector(refresh:)
                                                  userInfo:nil
                                                   repeats:YES];
    [refreshTimer retain];
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
        self.currentGames = nil;
        NSMenuItem *noMovesItem = [[NSMenuItem alloc] initWithTitle:NO_MOVES
                                                             action:nil 
                                                      keyEquivalent:@""];
        [noMovesItem setEnabled:NO];
        [[statusItem menu] insertItem:noMovesItem atIndex:GAME_LIST_START_INDEX];
        [self updateVisibleStatus];

    } else {
        insertionIndex = GAME_LIST_START_INDEX;
        [games enumerateObjectsUsingBlock:^(id gameObj, 
                                            NSUInteger idx, 
                                            BOOL *stop) {
            DBGame *game = (DBGame *) gameObj;
            game.delegate = self;            
            [self syncReadStatus:game];

            NSMenuItem *gameItem = 
            [[NSMenuItem alloc] initWithTitle:[game details] 
                                       action:@selector(openGame) 
                                keyEquivalent:@""];
            [gameItem setTarget:game];
            [gameItem setEnabled:YES];
            [[statusItem menu] insertItem:gameItem atIndex:insertionIndex];
            insertionIndex = insertionIndex + 1;
        }];
        self.currentGames = games;
        [self updateVisibleStatus];
    }
}


- (void)syncReadStatus:(DBGame *)game {
    if (self.currentGames != nil) {
        [self.currentGames enumerateObjectsUsingBlock:^(id gameObj, 
                                                        NSUInteger idx, 
                                                        BOOL *stop) {
            DBGame *currentGame = (DBGame *)gameObj;
            if ([currentGame.identifier isEqualToString:game.identifier]) {
                game.read = currentGame.read;
                *stop = YES;
            }
        }];
    }
}


- (NSInteger)unreadGamesCount {
    if (self.currentGames != nil) {
        NSIndexSet *unreadIndexes = 
        [self.currentGames indexesOfObjectsPassingTest:^BOOL(id obj, 
                                                             NSUInteger idx, 
                                                             BOOL *stop) {
            DBGame *game = (DBGame *)obj;
            return game.read == NO;
        }];
        
        return [unreadIndexes count];
    } else {
        return 0;
    }
}


- (void)clearMenu {
    [[statusMenu itemArray] enumerateObjectsUsingBlock:^(id itemObj, 
                                                         NSUInteger idx, 
                                                         BOOL *stop) {
        NSMenuItem *item = (NSMenuItem *) itemObj;
        if ([[item title] isEqualToString:NO_MOVES] ||
            [item action] == @selector(openGame)) {
            [statusMenu removeItem:item];
        }
    }];
}


- (void)updateVisibleStatus {
    NSInteger unreadCount = [self unreadGamesCount];
    if (unreadCount == 0) {
        [statusItem setImage:statusImage];
        [statusItem setToolTip:@"No moves waiting"];
    } else {
        [statusItem setImage:statusHighlightImage];
        [statusItem setToolTip:[NSString stringWithFormat:@"%d moves waiting", 
                                unreadCount]];
    }
}


- (IBAction)openStatus:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:STATUS_URL]];
}


- (void)openGame:(DBGame *)game {
    game.read = YES;
    // Since the game is read now, reset the title to drop the unread marker.
    NSMenuItem *item = [statusMenu itemAtIndex:
                        [statusMenu indexOfItemWithTarget:game andAction:nil]];
    [item setTitle:[game details]];
    
    [self updateVisibleStatus];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:game.link]];
}


- (IBAction)openRunningGames:(id)sender {
    NSString *urlString = 
    [NSString stringWithFormat:@"%@?%@", RUNNING_GAMES_URL, DRAGON_USERID];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlString]];
}


- (IBAction)openWaitingRoom:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:WAITING_ROOM_URL]];
}


- (IBAction)showSettings:(id)sender {
    NSLog(@"Got showSettings call.");
    prefs = [[DBPreferencesController alloc] initWithWindowNibName:@"PreferencesWindow"];
    [prefs showWindow:self];
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
    self.currentGames = nil;
    [prefs release];
    
    [super dealloc];
}


@end
