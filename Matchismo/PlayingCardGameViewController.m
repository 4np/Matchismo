//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Jeroen Wesbeek on 16/11/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@implementation PlayingCardGameViewController

- (Deck *)createDeck // abstract method
{
    return [[PlayingCardDeck alloc] init];
}

@end
