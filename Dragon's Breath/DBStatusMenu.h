//
//  DBStatusItem.h
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/12/11.
//  Copyright 2011 Hack Arts, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Growl/GrowlApplicationBridge.h>

#import "DBFeedParser.h"
#import "DBGame.h"
//#import "DBPassword.h"
#import "DBPreferencesController.h"

#define NOT_CONFIGURED @"Not Configured"
#define NO_MOVES @"No Moves Waiting"
#define RUNNING_GAMES_URL @"http://www.dragongoserver.net/show_games.php"
#define WAITING_ROOM_URL @"http://www.dragongoserver.net/waiting_room.php"
#define STATUS_URL @"http://www.dragongoserver.net/status.php"
#define GAME_LIST_START_INDEX 3

@interface DBStatusMenu : NSObject 
<DBStatusFeedDelegate, DBGameDelegate, DBPreferencesDelegate, 
GrowlApplicationBridgeDelegate> {
    IBOutlet NSMenu *statusMenu;
    IBOutlet NSMenu *editMenu;
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusHighlightImage;
    DBFeedParser *statusFeed;
    NSTimer *refreshTimer;
    NSArray *currentGames;
    NSInteger insertionIndex;
    DBPreferencesController *prefs;
    NSString *username;
    NSString *password;
    NSInteger refreshInterval;
    BOOL growlEnabled;
}

@property(nonatomic, retain) NSArray *currentGames;
@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *password;


- (void)loadPreferences;
- (BOOL)hasValidCredentials;
- (void)startTimer;
- (void)stopTimer;
- (void)receiveWakeNote:(NSNotification*)note;
- (IBAction)refresh:(id)sender;
- (void)clearMenu;
- (void)updateVisibleStatus;
- (void)syncReadStatus:(DBGame *)game;
- (NSInteger)unreadGamesCount;
- (IBAction)openStatus:(id)sender;
- (IBAction)openRunningGames:(id)sender;
- (IBAction)openWaitingRoom:(id)sender;
- (IBAction)showSettings:(id)sender;

@end