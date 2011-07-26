//
//  DBStatusItem.m
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/12/11.
//  Copyright 2011 Hack Arts, Inc. All rights reserved.
//

#import "DBStatusMenu.h"

@implementation DBStatusMenu

@synthesize currentGames, username, password;

- (void)awakeFromNib {
    statusItem = [[[NSStatusBar systemStatusBar] 
                   statusItemWithLength:NSSquareStatusItemLength] retain];
    statusImage = [NSImage imageNamed:@"disabled-icon.png"];
    statusHighlightImage = [NSImage imageNamed:@"black-icon.png"];
    
    [statusItem setImage:statusImage];
    [statusItem setAlternateImage:statusHighlightImage];
    
    [statusItem setMenu:statusMenu];
    [statusMenu setAutoenablesItems:NO];

    // Listen for events when the computer wakes from sleep, which otherwise
    // throws off the refresh schedule.
    [[[NSWorkspace sharedWorkspace] 
      notificationCenter] addObserver:self 
                             selector:@selector(receiveWakeNote:) 
                                 name:NSWorkspaceDidWakeNotification 
                               object:nil];
    
    // Register to post Growl notifications.
    [GrowlApplicationBridge setGrowlDelegate:self];

    [self loadCredentials];
    
    if ([self hasValidCredentials]) {
        [self refresh:nil];
        [self startTimer];
    } else {
        [self showSettings:nil];
    }
}


- (void)loadCredentials {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    self.username = [defaults stringForKey:@"username"];
    
    NSError *error = nil;
    self.password = [HAKeychain findPasswordForService:KEYCHAIN_SERVER
                                               account:self.username
                                              keychain:NULL
                                                 error:&error];
    if (self.password == nil && error != nil) {
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert runModal];
    }
}


- (BOOL)hasValidCredentials {
    if (self.username == nil || [self.username isEqualToString:@""]) {
        return NO;
    }
    
    if (self.password == nil || [self.password isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}


- (void)startTimer {
    [self stopTimer];
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:300.0
                                                    target:self
                                                  selector:@selector(refresh:)
                                                  userInfo:nil
                                                   repeats:YES];
    [refreshTimer retain];    
}


- (void)stopTimer {
    if (refreshTimer != nil) {
        [refreshTimer invalidate];
        [refreshTimer release];        
    }
}


- (void)receiveWakeNote:(NSNotification*)note {
    if ([self hasValidCredentials]) {
        // Kill off the current refresh schedule.
        [self stopTimer];
        
        // Wait a bit after wake before refreshing, so we don't make wake slower.
        [NSTimer scheduledTimerWithTimeInterval:10.0
                                         target:self
                                       selector:@selector(refresh:)
                                       userInfo:nil
                                        repeats:NO];
        
        // Reset the refresh schedule after the wake refresh.
        [self startTimer];
    }
}


- (IBAction)refresh:(id)sender {
    if ([self hasValidCredentials]) {
        statusFeed = [[DBFeedParser alloc] init];
        statusFeed.delegate = self;
        [statusFeed pollFeed:self.username withPassword:self.password];
    }
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
            [[NSMenuItem alloc] initWithTitle:[game detailsShowingReadState:YES] 
                                       action:@selector(openGame) 
                                keyEquivalent:@""];
            [gameItem setTarget:game];
            [gameItem setEnabled:YES];
            [[statusItem menu] insertItem:gameItem atIndex:insertionIndex];
            insertionIndex = insertionIndex + 1;
            
            if (game.read == NO) {
                [GrowlApplicationBridge 
                 notifyWithTitle:@"Dragon Go Server" 
                     description:[game detailsShowingReadState:NO] 
                notificationName:@"Game Waiting"
                        iconData:nil
                        priority:0
                        isSticky:NO
                    clickContext:[game detailsShowingReadState:YES]];
            }
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
            [[item title] isEqualToString:NOT_CONFIGURED] ||
            [item action] == @selector(openGame)) {
            [statusMenu removeItem:item];
        } else {
            [item setEnabled:YES];
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
    [item setTitle:[game detailsShowingReadState:YES]];
    
    [self updateVisibleStatus];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:game.link]];
}


- (IBAction)openRunningGames:(id)sender {
    NSString *urlString = 
    [NSString stringWithFormat:@"%@?user=%@", RUNNING_GAMES_URL, self.username];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlString]];
}


- (IBAction)openWaitingRoom:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:WAITING_ROOM_URL]];
}


- (IBAction)showSettings:(id)sender {
    if (prefs != nil) {
        [prefs release];
    }

    prefs = [[DBPreferencesController alloc] initWithWindowNibName:@"PreferencesWindow"];
    prefs.delegate = self;
    [prefs showWindow:self];
    [prefs retain];
}


- (void)preferencesUpdated {
    [self loadCredentials];
    if ([self hasValidCredentials]) {
        [self refresh:nil];
        [self startTimer];
    } else {
        [self showSettings:nil];
    }
}


#pragma mark -
#pragma mark Growl delegate methods

- (NSString *)applicationNameForGrowl {
    return @"Dragon's Breath";
}


- (NSDictionary *)registrationDictionaryForGrowl {
    NSArray *allNotifications = [NSArray arrayWithObjects:@"Game Waiting", nil];
    NSArray *defaultNotifications = [NSArray arrayWithObjects:@"Game Waiting", nil];
    return [NSDictionary dictionaryWithObjectsAndKeys:
            allNotifications, GROWL_NOTIFICATIONS_ALL,
            defaultNotifications, GROWL_NOTIFICATIONS_DEFAULT, 
            nil];
}


- (void) growlNotificationWasClicked:(id)clickContext {
    NSString *details = (NSString *)clickContext;
    NSUInteger index = [currentGames indexOfObjectPassingTest:^BOOL(id obj, 
                                                                    NSUInteger idx, 
                                                                    BOOL *stop) {
        DBGame *game = (DBGame *)obj;
        return [[game detailsShowingReadState:YES] isEqualToString:details];
    }];
    DBGame *game = (DBGame *)[currentGames objectAtIndex:index];        
    [self openGame:game];
}


- (void)dealloc {
    [[[NSWorkspace sharedWorkspace] 
      notificationCenter] removeObserver:self 
                                    name:NSWorkspaceDidWakeNotification 
                                  object:nil];
    [self stopTimer];
    [statusImage release];
    [statusHighlightImage release];
    [statusFeed release];
    self.currentGames = nil;
    self.username = nil;
    self.password = nil;

    if (prefs != nil) {
        [prefs release];
    }
    
    [super dealloc];
}


@end
