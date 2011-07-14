//
//  DBStatusItem.h
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/12/11.
//  Copyright 2011 Hack Arts, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DBPassword.h"
#import "DBFeedParser.h"

#define NO_MOVES @"No Moves Waiting"
#define RUNNING_GAMES_URL @"http://www.dragongoserver.net/show_games.php"
#define WAITING_ROOM_URL @"http://www.dragongoserver.net/waiting_room.php"
#define STATUS_URL @"http://www.dragongoserver.net/status.php"

@interface DBStatusItem : NSObject <DBStatusFeedDelegate> {
@private
    IBOutlet NSMenu *statusMenu;
    
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusHighlightImage;
    DBFeedParser *statusFeed;
    NSTimer *refreshTimer;
}

- (IBAction)refresh:(id)sender;
- (IBAction)openStatus:(id)sender;
- (IBAction)openRunningGames:(id)sender;
- (IBAction)openWaitingRoom:(id)sender;
- (void)clearMenu;

@end