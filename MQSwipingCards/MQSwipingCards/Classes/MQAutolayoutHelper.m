//
//  MQAutolayoutHelper.m
//  UIKitDynamics
//
//  Created by Daniel Devesa Derksen-Staats on 01/07/2016.
//  Copyright © 2016 Desfici. All rights reserved.
//

#import "MQAutolayoutHelper.h"

@implementation MQAutolayoutHelper

+ (void)keepAspectRatioForView:(UIView *)view {

    NSLayoutConstraint *aspectRationConstraint = [NSLayoutConstraint
                                                  constraintWithItem:view
                                                  attribute:NSLayoutAttributeWidth
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:view
                                                  attribute:NSLayoutAttributeHeight
                                                  multiplier:view.frame.size.width/view.frame.size.height
                                                  constant:0.0f];
    [view addConstraint:aspectRationConstraint];
}

+ (void)keepView:(UIView *)view insideSuperview:(UIView *)superview {

    CGFloat viewWidth = view.frame.size.width;
    
    NSDictionary *views = @{@"view": view};
    NSDictionary *metrics = @{@"viewWidth": @(viewWidth)};
    
    NSArray *cardVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[view]-(>=0)-|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:views];
    [superview addConstraints:cardVerticalConstraints];
    
    NSArray *cardHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[view(==viewWidth@250)]-(>=0)-|"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:views];
    [superview addConstraints:cardHorizontalConstraints];
}

+ (void)centerView:(UIView *)view insideSuperview:(UIView *)superview {

    [[self class] centerView:view horizontallyInsideSuperview:superview];
    [[self class] centerView:view verticallyInsideSuperview:superview];
}

+ (void)centerView:(UIView *)view horizontallyInsideSuperview:(UIView *)superview {

    NSLayoutConstraint *centerXConstraints = [NSLayoutConstraint constraintWithItem:view
                                                                          attribute:NSLayoutAttributeCenterX
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:superview
                                                                          attribute:NSLayoutAttributeCenterX
                                                                         multiplier:1.f constant:0.f];
    [superview addConstraint:centerXConstraints];
}

+ (void)centerView:(UIView *)view verticallyInsideSuperview:(UIView *)superview {

    NSLayoutConstraint *centerYConstraints = [NSLayoutConstraint constraintWithItem:view
                                                                          attribute:NSLayoutAttributeCenterY
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:superview
                                                                          attribute:NSLayoutAttributeCenterY
                                                                         multiplier:1.f constant:0.f];
    [superview addConstraint:centerYConstraints];
}

@end
