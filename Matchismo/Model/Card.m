//
//  Card.m
//  Matchismo
//
//  Created by Jeroen Wesbeek on 05/11/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import "Card.h"

@interface Card()
@property (nonatomic, strong) NSMutableArray* history;
@end

@implementation Card

- (NSMutableArray *)history {
    if (!_history) _history = [[NSMutableArray alloc] init];
    return _history;
}

- (NSArray *)matchHistory {
    return self.history;
}

- (int)match:(NSArray *)otherCards {
    int score = 0;
    
    for (Card *card in otherCards) { // fast enumeration
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    
    return score;
}

@end
