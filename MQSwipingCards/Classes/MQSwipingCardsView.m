//
//  MQSwipingCardsView.m
//  UIKitDynamics
//
//  Created by Daniel Devesa Derksen-Staats on 30/06/2016.
//  Copyright © 2016 Desfici. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "MQSwipingCardsView.h"

@interface MQSwipingCardsView()

@property (assign, nonatomic) NSUInteger index;
@property (assign, nonatomic) CGFloat throwingTreshold;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (strong, nonatomic) UIPushBehavior *pushBehavior;
@property (strong, nonatomic) NSMutableArray<UIView *> *cardViews;

@end

@implementation MQSwipingCardsView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [self setupView];
    }
    
    return self;
}

- (void)setupView {
    
    _index = 0;
    _throwingTreshold = 600;
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    _cardViews = [[NSMutableArray alloc] init];
    
    _cardsDisposition = MQSwipingCardsViewDispositionDisordered;
    _allowedDirections = MQSwipingCardsViewDirectionsRight
    | MQSwipingCardsViewDirectionsLeft
    | MQSwipingCardsViewDirectionsUp
    | MQSwipingCardsViewDirectionsDown;
    
    self.clipsToBounds = NO;
}

#pragma mark - Custom Accessors

- (void)setDataSource:(id<MQSwipingCardsViewDataSource>)dataSource {
    
    _dataSource = dataSource;
    
    [self createCardsFrom:0 to:4];
    [self addPanGestureToView:[self currentCardView] withSelector:@selector(moveCard:)];
}

- (void)createCardsFrom:(NSUInteger)fromIndex to:(NSUInteger)toIndex {
    
    for (int i = (int)fromIndex; i < toIndex; i++) {
        UIView *cardView = [self.dataSource swipingCardsView:self cardAtIndex:i];
        
        if (cardView) {
            [self.cardViews addObject:cardView];
            [self setupCardView:cardView forIndex:i];
        }
    }
}

#pragma mark - Public

- (UIView *)cardAtIndex:(NSUInteger)index {
    
    return [self.cardViews objectAtIndex:index];
}

- (void)swipeCardToDirection:(MQSwipingCardsViewDirection)direction {
    
    [UIView animateWithDuration:0.4
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.2
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self currentCardView].center = [self cardRunUpPositionForDirection:direction];
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [self handleCardWithVelocity:[self cardVelocityForDirection:direction]];
                         }
                     }];
}

- (CGPoint)cardRunUpPositionForDirection:(MQSwipingCardsViewDirection)direction {
    
    UIView *card = [self currentCardView];
    CGPoint cardPosition = card.center;
    CGFloat runUpDistance = card.frame.size.width / 5.0;
    
    switch (direction) {
        case MQSwipingCardsViewDirectionsNone:
            break;
        case MQSwipingCardsViewDirectionsLeft:
            cardPosition.x = cardPosition.x + runUpDistance;
            break;
        case MQSwipingCardsViewDirectionsRight:
            cardPosition.x = cardPosition.x - runUpDistance;
            break;
        case MQSwipingCardsViewDirectionsUp:
            cardPosition.y = cardPosition.y + runUpDistance;
            break;
        case MQSwipingCardsViewDirectionsDown:
            cardPosition.y = cardPosition.y - runUpDistance;
            break;
    }
    
    return cardPosition;
}

- (CGPoint)cardVelocityForDirection:(MQSwipingCardsViewDirection)direction {
    
    CGRect windowBounds = self.window.bounds;
    CGFloat xVelocity = 0.0;
    CGFloat yVelocity = 0.0;
    CGFloat multiplierFactor = 3.0;
    
    switch (direction) {
        case MQSwipingCardsViewDirectionsNone:
            break;
        case MQSwipingCardsViewDirectionsLeft:
            xVelocity = -windowBounds.size.width * multiplierFactor;
            break;
        case MQSwipingCardsViewDirectionsRight:
            xVelocity = windowBounds.size.width * multiplierFactor;
            break;
        case MQSwipingCardsViewDirectionsUp:
            yVelocity = -windowBounds.size.height * multiplierFactor;
            break;
        case MQSwipingCardsViewDirectionsDown:
            yVelocity = windowBounds.size.height * multiplierFactor;
    }
    
    return CGPointMake(xVelocity, yVelocity);
}

#pragma mark - Private

- (UIView *)currentCardView {
    return self.index <  self.cardViews.count? [self.cardViews objectAtIndex:self.index] : [self.cardViews lastObject];
}

- (void)addPanGestureToView:(UIView *)view withSelector:(SEL)selector{
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                           action:selector];
    [panGestureRecognizer setMaximumNumberOfTouches:1];
    [view addGestureRecognizer:panGestureRecognizer];
}

- (void)setupCardView:(UIView *)view forIndex:(NSUInteger)index {
    
    view.alpha = 0.0;
    
    [self addSubview:view];
    [self sendSubviewToBack:view];
    
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [MQAutolayoutHelper keepAspectRatioForView:view];
    [MQAutolayoutHelper keepView:view insideSuperview:self];
    [MQAutolayoutHelper centerView:view insideSuperview:self];
    
    CGFloat degrees = 0.0;
    
    switch (self.cardsDisposition) {
        case MQSwipingCardsViewDispositionPerfectStack:
            break;
        case MQSwipingCardsViewDispositionDisordered: {
            int negativeOrNot = ((arc4random() & 2) * 2) - 1;
            CGFloat radians = sin(0.8 * index) * negativeOrNot;
            degrees = radians * M_PI / 180;
        }
            break;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        view.alpha = 1.0;
        view.transform = CGAffineTransformMakeRotation(degrees);
    }];
}

- (void)handleCardWithVelocity:(CGPoint)velocity {
    
    CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
    
    if (magnitude > self.throwingTreshold) {
        [self.animator removeAllBehaviors];
        
        self.pushBehavior = [[UIPushBehavior alloc]
                             initWithItems:@[self.currentCardView]
                             mode:UIPushBehaviorModeContinuous];
        self.pushBehavior.pushDirection = CGVectorMake((velocity.x / 10) , (velocity.y / 10));
        self.pushBehavior.magnitude = magnitude;
        
        [self setupCardBehavior];
        [self.animator addBehavior:self.pushBehavior];
        
        __weak MQSwipingCardsView *weakSelf = self;
        
        self.pushBehavior.action = ^{
            
            [weakSelf handlePushBehaviourAction];
        };
    } else {
        [self.delegate swipingCardsView:self didCancelSwipingAtIndex:self.index];
        [self resetCard];
    }
}

- (void)setupCardBehavior {
    
    UIDynamicItemBehavior *cardBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.currentCardView]];
    cardBehavior.friction = 1.0;
    
    NSInteger angle = arc4random_uniform(3);
    [cardBehavior addAngularVelocity:angle forItem:self.currentCardView];
    
    [self.animator addBehavior:cardBehavior];
}

- (void)resetCard {
    
    [self.animator removeAllBehaviors];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.currentCardView.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
                         self.currentCardView.transform = CGAffineTransformIdentity;
                     } completion:nil];
}

- (void)handlePushBehaviourAction {
    
    UIView *currentCard = [self currentCardView];
    
    if ([self isCardOutOfTheWindow:currentCard]) {
        
        MQSwipingCardsViewDirection direction = [self getDirectionOfTheSwipeForCard:currentCard];
        
        BOOL allowedDirection = (self.allowedDirections & direction) != 0;
        
        if (allowedDirection) {
            
            [self.animator removeAllBehaviors];
            [currentCard removeFromSuperview];
            
            [self.delegate swipingCardsView:self
                        didSwipeCardAtIndex:self.index
                                inDirection:direction];
            
            NSUInteger numberOfCards = [_dataSource numberOfCardsInSwipingCardsView:self];
            
            if (self.cardViews.count < numberOfCards) {
                [self createCardsFrom:self.cardViews.count to:self.cardViews.count + 1];
            }
            
            self.index ++;
            
            [self addPanGestureToView:[self currentCardView] withSelector:@selector(moveCard:)];
            
        } else {
            [self.delegate swipingCardsView:self didCancelSwipingAtIndex:self.index];
            [self resetCard];
        }
    }
}

- (BOOL)isCardOutOfTheWindow:(UIView *)card {
    CGRect windowBounds = self.window.bounds;
    return !CGRectIntersectsRect(card.frame, windowBounds);
}

- (MQSwipingCardsViewDirection)getDirectionOfTheSwipeForCard:(UIView *)card {
    
    MQSwipingCardsViewDirection direction = MQSwipingCardsViewDirectionsNone;
    CGRect windowBounds = self.window.bounds;
    
    if (card.center.x > windowBounds.size.width) {
        direction = MQSwipingCardsViewDirectionsRight;
    } else if (card.center.x < 0) {
        direction = MQSwipingCardsViewDirectionsLeft;
    } else if (card.center.y > windowBounds.size.height) {
        direction = MQSwipingCardsViewDirectionsDown;
    } else if (card.center.y < 0) {
        direction = MQSwipingCardsViewDirectionsUp;
    }
    
    return direction;
}

- (void)moveCard:(id)sender {
    
    UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)sender;
    CGPoint locationInCard = [panGestureRecognizer locationInView:self.currentCardView];
    CGPoint locationInView = [panGestureRecognizer locationInView:self];
    
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self setupAttachmentBehaviorTouchLocationInCard:locationInCard
                                              andAnchorPoint:locationInView];
            break;
        case UIGestureRecognizerStateChanged:
            [self.attachmentBehavior setAnchorPoint:locationInView];
            [self.delegate swipingCardsView:self
                         swipingCardAtIndex:self.index
                               withPosition:[self currentCardView].center];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            [self handleCardWithVelocity:[panGestureRecognizer velocityInView:self.superview]];
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStatePossible:
            break;
    }
}

- (void)setupAttachmentBehaviorTouchLocationInCard:(CGPoint)locationInCard andAnchorPoint:(CGPoint)anchorPoint {
    
    UIOffset centerOffset = UIOffsetMake(locationInCard.x - CGRectGetMidX(self.currentCardView.bounds),
                                         locationInCard.y - CGRectGetMidY(self.currentCardView.bounds));
    
    [self.animator removeAllBehaviors];
    self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.currentCardView
                                                        offsetFromCenter:centerOffset
                                                        attachedToAnchor:anchorPoint];
    [self.animator addBehavior:self.attachmentBehavior];
}

@end
