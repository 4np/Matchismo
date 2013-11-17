//
//  Card.h
//  Matchismo
//
//  Created by Jeroen Wesbeek on 05/11/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>   // old style import (backwards compatible in iOS 7)
// @import Foundation;              // new style import of an entire framework (>= iOS 7)

@interface Card : NSObject

@property (nonatomic, strong) NSString *contents;

@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;

- (NSArray *)matchHistory;
- (int)match:(NSArray *)otherCards;

@end