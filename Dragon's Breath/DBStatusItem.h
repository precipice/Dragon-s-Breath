//
//  DBStatusItem.h
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DBPassword.h"
#import "DBStatusFeed.h"

#define STATUS_URL @"http://www.dragongoserver.net/status.php"
#define RUNNING_GAMES_URL @"http://www.dragongoserver.net/show_games.php"
#define WAITING_ROOM_URL @"http://www.dragongoserver.net/waiting_room.php"

@interface DBStatusItem : NSObject {
@private
    IBOutlet NSMenu *statusMenu;
    
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusHighlightImage;
    DBStatusFeed *statusFeed;
}

- (IBAction)refresh:(id)sender;
- (IBAction)openStatus:(id)sender;
- (IBAction)openRunningGames:(id)sender;
- (IBAction)openWaitingRoom:(id)sender;



@end