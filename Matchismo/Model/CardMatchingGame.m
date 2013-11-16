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
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
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

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
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
                } else {
                    // mismatch penalty when cards do not match
                    self.score -= (MISMATCH_PENALTY * (self.gameType + 1));
                    
                    // flip other card(s)
                    for (Card *otherCard in matchedCards) {
                        otherCard.chosen = NO;
                    }
                }
            }
            
            
            
//            for (Card *otherCard in self.cards) {
//                if (otherCard.isChosen && !otherCard.isMatched) {
//                    int matchScore = [card match:@[otherCard]];
//                    
//                    if (matchScore) {
//                        // increase score
//                        self.score += (matchScore * MATCH_BONUS);
//                        
//                        // mark cards as matched
//                        card.matched = YES;
//                        otherCard.matched = YES;
//                    } else {
//                        // mismath penalty when cards do no match
//                        self.score -= MISMATCH_PENALTY;
//                        
//                        // flip othercard
//                        otherCard.chosen = NO;
//                    }
//
//                    
//                    break;
//                }
//            }
            
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

@end
