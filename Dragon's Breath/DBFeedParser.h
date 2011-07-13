//
//  DBStatusFeed.h
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DBPassword.h"
#import "MWFeedParser.h"
#import "RegexKitLite.h"

#define STATUS_URL @"http://www.dragongoserver.net/rss/status.php"

@interface DBFeedParser : NSObject <MWFeedParserDelegate> {
@private
    
}

@property(nonatomic, retain) id delegate;
@property(nonatomic, retain) NSMutableArray *games;

-(void) pollFeed;

@end


@protocol DBStatusFeedDelegate

- (void)feedLoaded:(NSArray *)games;

@end

