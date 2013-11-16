//
//  PlayingCard.m
//  Matchismo
//
//  Created by Jeroen Wesbeek on 05/11/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(PlayingCard *)card with:(PlayingCard *)otherCard {
    int score = 0;
    
    if ([card.suit isEqualToString:otherCard.suit]) {
        score = 1;
    } else if (card.rank == otherCard.rank) {
        score = 4;
    }
    
    return score;
}

// override 'match' inherited from Card
- (int)match:(NSArray *)otherCards {
    int score = 0;
    int matchCount = 0;
    
    NSMutableArray *matchCards = [[NSMutableArray alloc] initWithArray:otherCards];
    int matchScore = 0;
    
    for (Card *card in otherCards) {
        // make sure card is really a PlayingCard
        if ([card isKindOfClass:[PlayingCard class]]) {
            // cast it explicitely to PlayingCard so the compiler is aware as well
            PlayingCard *otherCard = (PlayingCard *)card;
            
            // match other card with ourselve
            matchScore = [self match:self with:otherCard];
            if (matchScore) matchCount++;
            score += matchScore;
            
            // remove card from matchCards stack so we won't match multiple times nor ourselve
            [matchCards removeObject:card];
            
            // and match it with the other cards
            for (Card *matchCard in matchCards) {
                if ([matchCard isKindOfClass:[PlayingCard class]]) {
                    PlayingCard *otherMatchCard = (PlayingCard *)matchCard;
                    matchScore = [self match:otherCard with:otherMatchCard];
                    if (matchScore) matchCount++;
                    score += matchScore;
                }
            }
        }
    }

    return score;
}

- (BOOL)matchCardSuit:(PlayingCard *)card withOtherCard:(PlayingCard *)otherCard {
    return ([card.suit isEqualToString:otherCard.suit]) ? YES : NO;
}

- (BOOL)matchCardRank:(PlayingCard *)card withOtherCard:(PlayingCard *)otherCard {
    return (card.rank == otherCard.rank) ? YES : NO;
}


- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit; // because we provide the setter AND the getter

+ (NSArray *)validSuits
{
    return @[@"♣", @"♠", @"♦", @"♥"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank
{
    return ([[PlayingCard rankStrings] count] - 1);
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
