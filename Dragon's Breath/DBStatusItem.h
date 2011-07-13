//
//  DBStatusItem.h
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/12/11.
//  Copyright 2011 Marc Hedlund. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DBPassword.h"
#import "DBFeedParser.h"

#define RUNNING_GAMES_URL @"http://www.dragongoserver.net/show_games.php"
#define WAITING_ROOM_URL @"http://www.dragongoserver.net/waiting_room.php"

@interface DBStatusItem : NSObject <DBStatusFeedDelegate> {
@private
    IBOutlet NSMenu *statusMenu;
    
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusHighlightImage;
    DBFeedParser *statusFeed;
}

- (IBAction)refresh:(id)sender;
- (IBAction)openStatus:(id)sender;
- (IBAction)openRunningGames:(id)sender;
- (IBAction)openWaitingRoom:(id)sender;
- (void)clearMenu;

@end