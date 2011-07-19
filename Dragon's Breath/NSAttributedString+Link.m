//
//  NSAttributedString+Link.m
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/17/11.
//  Copyright 2011 Hack Arts, LLC. All rights reserved.
//

#import "NSAttributedString+Link.h"


@implementation NSAttributedString (NSAttributedString_Link)


+(id)linkFromString:(NSString*)linkText withURL:(NSString*)href {
    NSDictionary *attributes = 
    [[NSDictionary alloc] initWithObjectsAndKeys:
     [NSFont fontWithName:@"Lucida Grande" size:12], NSFontAttributeName, nil];
    
    NSMutableAttributedString* link = [[NSMutableAttributedString alloc] 
                                       initWithString:linkText
                                       attributes:attributes];
    NSRange range = NSMakeRange(0, [link length]);
    NSURL *hrefURL = [NSURL URLWithString:href];

    [link beginEditing];
    [link addAttribute:NSLinkAttributeName 
                 value:[hrefURL absoluteString] range:range];

    [link addAttribute:NSForegroundColorAttributeName 
                 value:[NSColor blueColor] range:range];

    [link addAttribute:NSUnderlineStyleAttributeName 
                 value:[NSNumber numberWithInt:NSSingleUnderlineStyle] 
                 range:range];
    [link endEditing];

    return [link autorelease];
}


@end
