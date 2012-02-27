//
//  DBStatusFeed.m
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/12/11.
//  Copyright 2011 Hack Arts, LLC. All rights reserved.
//

#import "DBFeedParser.h"


@implementation DBFeedParser

@synthesize delegate, games;

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (void)pollFeed:(NSString *)username withPassword:(NSString *)password {
    NSString *urlString = [NSString stringWithFormat:@"%@?userid=%@&passwd=%@", 
                           STATUS_RSS_URL, 
                           username,
                           password];
    NSURL *feedURL = [NSURL URLWithString:urlString];
    
    self.games = [NSMutableArray arrayWithCapacity:10];
    MWFeedParser *feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    feedParser.delegate = self;
    feedParser.feedParseType = ParseTypeFull;
    feedParser.connectionType = ConnectionTypeAsynchronously;
    [feedParser parse];
    [feedParser release];
}


- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    if (![item.title isEqualToString:@"Empty lists"]) {
        // if we get an error, skip it
        NSString *title = [item.title stringByConvertingHTMLToPlainText];
        if ([title hasPrefix:@"ERROR:"]) {
            return;
        }

        NSString *regex = @"Game\\:\\s+(\\d+)\\s+\\-\\s+"
                           "Opponent\\:\\s+([\\s\\w\\d]+)\\s+"
                           "\\(([^\\)]+)\\)\\s+\\-\\s+"
                           "Color\\:\\s+(\\w)\\s+\\-\\s+"
                           "Move\\:\\s+(\\d+)";
        NSDictionary *rawFields = [[item.summary stringByConvertingHTMLToPlainText]
                                   dictionaryByMatchingRegex:regex
                                         withKeysAndCaptures:@"gameId", 1, 
                                                             @"opponentName", 2, 
                                                             @"opponentHandle", 3,
                                                             @"color", 4,
                                                             @"move", 5,
                                                             NULL];
        NSMutableDictionary *gameFields = [NSMutableDictionary 
                                           dictionaryWithDictionary:rawFields];        
        [gameFields setValue:title forKey:@"title"];
        [gameFields setValue:item.identifier forKey:@"identifier"];
        [gameFields setValue:item.link forKey:@"link"];
        [gameFields setValue:item.date forKey:@"date"];
        NSLog(@"Game fields: %@", gameFields);
        
        DBGame *game = [[[DBGame alloc] initWithDictionary:gameFields] autorelease];
        [self.games addObject:game];
    }
}


- (void)feedParserDidFinish:(MWFeedParser *)parser {
    [self.delegate feedLoaded:games];
}


- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    [self.delegate feedLoaded:nil];
}


- (void)dealloc {
    self.delegate = nil;
    self.games = nil;
    [super dealloc];
}


@end
