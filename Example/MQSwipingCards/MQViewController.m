//
//  MQViewController.m
//  MQSwipingCards
//
//  Created by Daniel Devesa Derksen-Staats on 07/05/2016.
//  Copyright (c) 2016 Daniel Devesa Derksen-Staats. All rights reserved.
//

#import "MQViewController.h"

#import <MQSwipingCards/MQSwipingCardsView.h>

@interface MQViewController () <MQSwipingCardsViewDataSource, MQSwipingCardsViewDelegate>

@property (weak, nonatomic) IBOutlet MQSwipingCardsView *swipingCardsView;

@end

@implementation MQViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.swipingCardsView.allowedDirections = MQSwipingCardsViewDirectionsRight | MQSwipingCardsViewDirectionsLeft;
    self.swipingCardsView.dataSource = self;
    self.swipingCardsView.delegate = self;
}

#pragma mark - MQSwipingCardsViewDataSource

- (UIView *)swipingCardsView:(MQSwipingCardsView *)view cardAtIndex:(NSUInteger)index {
    
    UIView *cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    cardView.backgroundColor = [UIColor orangeColor];
    cardView.layer.borderWidth = 1.0;
    cardView.layer.borderColor = [UIColor blackColor].CGColor;
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:cardView.frame];
    numberLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)index];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.font = [UIFont systemFontOfSize:100.0];
    
    [cardView addSubview:numberLabel];
    
    [numberLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [MQAutolayoutHelper centerView:numberLabel insideSuperview:cardView];
    
    return cardView;
}

- (NSUInteger)numberOfCardsInSwipingCardsView:(MQSwipingCardsView *)view {
    return 20;
}

#pragma mark - MQSwipingCardsViewDelegate

- (void)swipingCardsView:(MQSwipingCardsView *)view didCancelSwipingAtIndex:(NSUInteger)index {
    NSLog(@"Canceled at index %lu!", index);
}

- (void)swipingCardsView:(MQSwipingCardsView *)view
      swipingCardAtIndex:(NSUInteger)index
            withPosition:(CGPoint)position {
    NSLog(@"Swiping card number %lu, now in position (%f - %f)", index, position.x, position.y);
}

- (void)swipingCardsView:(MQSwipingCardsView *)view
     didSwipeCardAtIndex:(NSUInteger)index
             inDirection:(MQSwipingCardsViewDirection)direction {
    NSLog(@"Swiped card number %lu to direction %lu", index, direction);
}

#pragma mark - Actions

- (IBAction)leftButtonPressed:(id)sender {
    [self.swipingCardsView swipeCardToDirection:MQSwipingCardsViewDirectionsLeft];
}

- (IBAction)rightButtonPressed:(id)sender {
    [self.swipingCardsView swipeCardToDirection:MQSwipingCardsViewDirectionsRight];
}

@end

