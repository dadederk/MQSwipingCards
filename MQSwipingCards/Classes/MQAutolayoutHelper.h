//
//  MQAutolayoutHelper.h
//  UIKitDynamics
//
//  Created by Daniel Devesa Derksen-Staats on 01/07/2016.
//  Copyright © 2016 Desfici. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MQAutolayoutHelper : NSObject

+ (void)keepAspectRatioForView:(UIView *)view;
+ (void)keepView:(UIView *)view insideSuperview:(UIView *)superview;

+ (void)centerView:(UIView *)view insideSuperview:(UIView *)superview;
+ (void)centerView:(UIView *)view horizontallyInsideSuperview:(UIView *)superview;
+ (void)centerView:(UIView *)view verticallyInsideSuperview:(UIView *)superview;

@end
