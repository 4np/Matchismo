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
    
    // create a mutable array containing the other cards
    NSMutableArray *matchArray = [[NSMutableArray alloc] initWithArray:otherCards];
    [matchArray addObject:self];
    
    // iterate over all cards
    while ([matchArray count]) {
        Card *matchCard = matchArray.lastObject;

        // make cure card really is a PlayingCard
        if ([matchCard isKindOfClass:[PlayingCard class]]) {
            // cast it explicitely to PlayingCard
            PlayingCard *card = (PlayingCard *)matchCard;
            
            // remove it from the matchArray
            [matchArray removeObject:matchCard];
            
            // iterate over the remaining cards in the match array
            for (Card *otherMatchCard in matchArray) {
                if ([otherMatchCard isKindOfClass:[PlayingCard class]]) {
                    PlayingCard *otherCard = (PlayingCard *)otherMatchCard;
                    
                    // compare the two cards
                    if ([card.suit isEqualToString:otherCard.suit]) {
                        score += 1;
                        matchCount++;
                    } else if (card.rank == otherCard.rank) {
                        score += 4;
                        matchCount++;
                    }
                }
            }
        }
    }
    
    // check the number of matched cards to the gametype
    if (matchCount < [otherCards count]) {
        // we matched less cards (e.g. 2 in a 3 card game) than we should
        if (score > 1) score = (int) round(score * 0.8f); // apply penalty
    }

    return score;
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
