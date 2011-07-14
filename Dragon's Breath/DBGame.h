//
//  DBGame.h
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBStatusMenu;

@interface DBGame : NSObject {
@private
    NSString *gameId;
    NSString *link;
    NSString *title;
    NSDate *date;
    NSString *opponentName;
    NSString *opponentHandle;
    NSString *color;
    NSString *move;
    DBStatusMenu *statusItem;
}

@property(nonatomic, copy) NSString *gameId;
@property(nonatomic, copy) NSString *link;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, retain) NSDate *date;
@property(nonatomic, copy) NSString *opponentName;
@property(nonatomic, copy) NSString *opponentHandle;
@property(nonatomic, copy) NSString *color;
@property(nonatomic, copy) NSString *move;
@property(nonatomic, retain) DBStatusMenu *statusItem;

- (id)initWithDictionary:(NSDictionary *)gameFields;
- (void)openGame;
- (NSString *)details;

@end
