//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Jeroen Wesbeek on 05/11/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//
// Abstract class. Must implement methods as described below.

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController <UIAlertViewDelegate>

// protected
// for subclasses
- (Deck *)createDeck; // abstract method

@end
