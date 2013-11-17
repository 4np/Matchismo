//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Jeroen Wesbeek on 05/11/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;    // make score writable in out private API
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property (nonatomic, strong) NSMutableArray *history;
@end

@implementation CardMatchingGame

- (NSMutableArray *)history {
    if (!_history) _history = [[NSMutableArray alloc] init];
    return _history;
}

- (NSArray *)matchHistory {
    return self.history;
}

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (NSUInteger i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
 
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }

    return self;
}

//#define MISMATCH_PENALTY 2            // it's a matter of preference what to use, however:
static const int MISMATCH_PENALTY = 2;  // this is typed so it will show in the debugger
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            NSString *feedback = [[NSString alloc] initWithFormat:@"Un-picked %@", card.contents];
            [self.history addObject:@[feedback]];
        } else {
            // match against other card(s)
            NSMutableArray *matchedCards = [[NSMutableArray alloc] init];
            
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    // add matched card to array
                    [matchedCards addObject:otherCard];
                }
            }
            
            // check if the number of cards for this gametype have been flipped
            if ([matchedCards count] == (self.gameType + 1)) {
                // calculate match score
                int matchScore = [card match:matchedCards];
                
                if (matchScore) {
                    // increase score
                    self.score += (matchScore * MATCH_BONUS);
                    
                    // mark cards as matched
                    card.matched = YES;
                    for (Card *otherCard in matchedCards) {
                        otherCard.matched = YES;
                    }
                    
                    [self.history addObject:[card matchHistory]];
                } else {
                    // mismatch penalty when cards do not match
                    long penalty = (MISMATCH_PENALTY * (self.gameType + 1));
                    self.score -= penalty;
                    
                    // flip other card(s)
                    for (Card *otherCard in matchedCards) {
                        otherCard.chosen = NO;
                    }
                    
                    NSString *matchHistory = card.matchHistory.lastObject;
                    NSString *feedback = [matchHistory stringByAppendingFormat:@" %ld point penalty!", penalty];
                    [self.history addObject:@[feedback]];
                }
            } else {
                NSString *feedback = [[NSString alloc] initWithFormat:@"Picked %@", card.contents];
                [self.history addObject:@[feedback]];
            }
            
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

@end
