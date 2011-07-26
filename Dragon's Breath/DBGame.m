//
//  DBGame.m
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/13/11.
//  Copyright 2011 Hack Arts, LLC. All rights reserved.
//

#import "DBGame.h"


@implementation DBGame

@synthesize identifier, gameId, link, title, date, opponentName, opponentHandle, 
            color, move, read, delegate;

- (id)initWithDictionary:(NSDictionary *)gameFields {
    self = [self init];
    if (self) {
        self.identifier = [gameFields valueForKey:@"identifier"];
        self.gameId = [gameFields valueForKey:@"gameId"];
        self.link = [gameFields valueForKey:@"link"];
        self.title = [gameFields valueForKey:@"title"];
        self.date = [gameFields valueForKey:@"date"];
        self.opponentName = [gameFields valueForKey:@"opponentName"];
        self.opponentHandle = [gameFields valueForKey:@"opponentHandle"];
        self.color = [gameFields valueForKey:@"color"];
        self.move = [gameFields valueForKey:@"move"];
        self.read = NO;
    }
    
    return self;
}

- (NSString *)detailsShowingReadState:(BOOL)showReadState {
    // So far every valid game entry I've seen has had an opponent name in it,
    // and every bogey has had a title.
    if (self.opponentName != nil) {
        NSString *readMarker = @"";
        if (showReadState == YES && self.read == NO) {
            readMarker = @"\u2022 ";
        }
        return [NSString stringWithFormat:@"%@%@ (%@): %@ - %@", readMarker,
                self.opponentName, self.opponentHandle, self.color, self.move];
    } else if (self.title != nil) {
        return self.title;
    } else {
        return @"[Unrecognized message]";
    }
}


- (NSString *)description {
    return [NSString stringWithFormat:@"Game %@, <%@>: %@ (%@), %@ - %@",
            self.gameId, self.link, self.opponentName, self.opponentHandle,
            self.color, self.move];
}


- (void)openGame {
    [self.delegate openGame:self];
}


- (void)dealloc {
    self.gameId = nil;
    self.link = nil;
    self.title = nil;
    self.date = nil;
    self.opponentName = nil;
    self.opponentHandle = nil;
    self.color = nil;
    self.move = nil;
    self.delegate = nil;

    [super dealloc];
}

@end
