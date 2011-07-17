//
//  NSAttributedString+Link.h
//  Dragon's Breath
//
//  Created by Marc Hedlund on 7/17/11.
//  Copyright 2011 Hack Arts, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSAttributedString (NSAttributedString_Link)

+(id)linkFromString:(NSString*)linkText withURL:(NSString*)href;

@end
