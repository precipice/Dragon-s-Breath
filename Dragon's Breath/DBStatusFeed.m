//
//  DBStatusFeed.m
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DBStatusFeed.h"


@implementation DBStatusFeed


- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (void)pollFeed {
    NSString *urlString = [NSString stringWithFormat:@"%@?%@", STATUS_URL, DRAGON_AUTH_INFO];
    NSURL *feedURL = [NSURL URLWithString:urlString];
    MWFeedParser *feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    feedParser.delegate = self;
    feedParser.feedParseType = ParseTypeFull;
    feedParser.connectionType = ConnectionTypeAsynchronously;
    [feedParser parse];
}


- (void)feedParserDidStart:(MWFeedParser *)parser {
    NSLog(@"Parser started.");    
}


- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    NSLog(@"Parsed feed info: %@", info);
    NSLog(@"Feed title: %@", info.title);
    NSLog(@"Feed link: %@", info.link);
    NSLog(@"Feed summary: %@", info.summary);    
}


- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    NSLog(@"Parsed feed item: %@", item);
    NSLog(@"Item title: %@", item.title);
    NSLog(@"Item link: %@", item.link);
    NSLog(@"Item date: %@", item.date);
    NSLog(@"Item updated: %@", item.updated);
    NSLog(@"Item summary: %@", item.summary);
    NSLog(@"Item content: %@", item.content);
    NSLog(@"Item enclosures: %@", item.enclosures);
    NSLog(@"Item identifier: %@", item.identifier);    
}


- (void)feedParserDidFinish:(MWFeedParser *)parser {
    NSLog(@"Parser finished.");
}


- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"Parser failed: %@", error);
}


- (void)dealloc {
    [super dealloc];
}


@end
