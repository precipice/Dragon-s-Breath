//
//  DBGame.m
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DBGame.h"


@implementation DBGame

@synthesize gameId, link, title, date, opponentName, opponentHandle, color, move;

- (id)initWithDictionary:(NSDictionary *)gameFields {
    self = [self init];
    if (self) {
        self.gameId = [gameFields valueForKey:@"gameId"];
        self.link = [gameFields valueForKey:@"link"];
        self.title = [gameFields valueForKey:@"title"];
        self.date = [gameFields valueForKey:@"date"];
        self.opponentName = [gameFields valueForKey:@"opponentName"];
        self.opponentHandle = [gameFields valueForKey:@"opponentHandle"];
        self.color = [gameFields valueForKey:@"color"];
        self.move = [gameFields valueForKey:@"move"];        
    }
    
    return self;
}

- (NSString *)details {
    return [NSString stringWithFormat:@"%@ (%@): %@ - %@", 
            self.opponentName, self.opponentHandle, self.color, self.move];

}


- (NSString *)description {
    return [NSString stringWithFormat:@"Game %@, <%@>: %@ (%@), %@ - %@",
            self.gameId, self.link, self.opponentName, self.opponentHandle,
            self.color, self.move];
}


- (void)openGame {
    NSLog(@"Opening game.");
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:self.link]];
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

    [super dealloc];
}

@end
