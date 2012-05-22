//
//  DBStatusFeed.h
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/12/11.
//  Copyright 2011 Hack Arts, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DBGame.h"
//#import "DBPassword.h"
#import "MWFeedParser.h"
#import "NSString+HTML.h"
#import "RegexKitLite.h"

#define STATUS_RSS_URL @"http://www.dragongoserver.net/rss/status.php"

@interface DBFeedParser : NSObject <MWFeedParserDelegate> {
@private
    id delegate;
    NSMutableArray *games;
}

@property(nonatomic, retain) id delegate;
@property(nonatomic, retain) NSMutableArray *games;

-(void) pollFeed:(NSString *)username withPassword:(NSString *)password;

@end


@protocol DBStatusFeedDelegate

- (void)feedLoaded:(NSArray *)games;

@end

