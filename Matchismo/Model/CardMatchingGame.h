//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Jeroen Wesbeek on 05/11/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

- (NSArray *)matchHistory;

@property (nonatomic, readonly) NSInteger score; // make score read only in public API
@property (nonatomic) NSInteger gameType; // the type of the game (0=two card, 1=three card)
@end
