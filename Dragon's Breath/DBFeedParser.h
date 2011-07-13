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

#define STATUS_URL @"http://www.dragongoserver.net/rss/status.php"

@interface DBStatusFeed : NSObject <MWFeedParserDelegate> {
@private
    
}

-(void) pollFeed;

@end
