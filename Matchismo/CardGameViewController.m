//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Jeroen Wesbeek on 05/11/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (nonatomic, strong) Deck *deck;
@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameTypeControlButton;
@property (weak, nonatomic) IBOutlet UITextView *gameHistory;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    return _game;
}

- (Deck *)createDeck { // abstract method
    return nil;
}

- (IBAction)deal {
    // ask to confirm re-dealing
    UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@"Re-deal"
                                                      message:@"Are you sure you want to re-deal the deck and start over?"
                                                     delegate:self
                                            cancelButtonTitle:@"No"
                                            otherButtonTitles:@"Yes", nil];
    [warning show];
}

// handle alert view confirmation
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {
        [self reDeal];
    }
}

- (void)reDeal {
    // enable the game type segmented control
    self.gameTypeControlButton.enabled = YES;
    
    self.game = nil;
    self.game.gameType = self.gameTypeControlButton.selectedSegmentIndex;
    [self updateUI];
}

- (IBAction)changeGameType:(UISegmentedControl *)sender {
    NSString *cardsToMatch = (self.gameTypeControlButton.selectedSegmentIndex) ? @"three" : @"two";
    
    UIAlertView *feedback = [[UIAlertView alloc] initWithTitle:@"Gametype Changed"
                                                       message:[[NSString alloc] initWithFormat:@"You now have to match %@ cards", cardsToMatch]
                                                      delegate:nil
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil];
    [feedback show];
    
    [self reDeal];
}


- (IBAction)touchCardButton:(UIButton *)sender {
    // disable the game type segmented control
    self.gameTypeControlButton.enabled = NO;
    
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    
    NSArray *lastMatchHistory = [[self.game matchHistory] lastObject];
    self.gameHistory.text = [lastMatchHistory componentsJoinedByString:@"\n"];
    
    [self updateUI];
}

- (void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    
    // %ld and explicit typecast to long to support 32bit as well as 64bit
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long) self.game.score];
}

- (NSString *)titleForCard:(Card *)card {
    return (card.isChosen) ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:(card.isChosen) ? @"cardFront" : @"cardBack"];
}

@end
