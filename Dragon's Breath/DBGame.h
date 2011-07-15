//
//  DBGame.h
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBGame : NSObject {
@private
    NSString *identifier;
    NSString *gameId;
    NSString *link;
    NSString *title;
    NSDate *date;
    NSString *opponentName;
    NSString *opponentHandle;
    NSString *color;
    NSString *move;
    BOOL read;
    id delegate;
}

@property(nonatomic, copy) NSString *identifier;
@property(nonatomic, copy) NSString *gameId;
@property(nonatomic, copy) NSString *link;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, retain) NSDate *date;
@property(nonatomic, copy) NSString *opponentName;
@property(nonatomic, copy) NSString *opponentHandle;
@property(nonatomic, copy) NSString *color;
@property(nonatomic, copy) NSString *move;
@property(nonatomic) BOOL read;
@property(nonatomic, retain) id delegate;

- (id)initWithDictionary:(NSDictionary *)gameFields;
- (void)openGame;
- (NSString *)details;

@end


@protocol DBGameDelegate

- (void)openGame:(DBGame *)game;

@end

