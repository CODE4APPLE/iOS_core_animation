//
//  SpringLayerAnimation.m
//  animatedPageControl
//
//  Created by Jack on 16/8/13.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import "SpringLayerAnimation.h"

@implementation SpringLayerAnimation

#pragma mark - main class methods

+ (CABasicAnimation *)create:(NSString *)keypath
                    duration:(CFTimeInterval)duration
                   fromValue:(id)fromValue
                     toValue:(id)toValue
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:keypath];
    anim.fromValue = fromValue;
    anim.toValue = toValue;
    anim.repeatCount = 0;
    anim.duration = duration;
    
    return anim;
}

+ (CAKeyframeAnimation *)createSpring:(NSString *)keypath
                             duration:(CFTimeInterval)duration
               usingSpringWithDamping:(CGFloat)damping
                initialSpringVelocity:(CGFloat)velocity
                            fromValue:(id)fromValue
                              toValue:(id)toValue
{
    CGFloat dampingFactor  = 10.0;
    CGFloat velocityFactor = 10.0;
    
    NSMutableArray *values = [SpringLayerAnimation animationValues:fromValue
                                                           toValue:toValue
                                            usingSpringWithDamping:damping * dampingFactor
                                             initialSpringVelocity:velocity * velocityFactor
                                                          duration:duration];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:keypath];
    anim.values = values;
    anim.duration = duration;
    
    return anim;
}

#pragma mark - helper methods

+(NSMutableArray *) animationValues:(id)fromValue
                            toValue:(id)toValue
             usingSpringWithDamping:(CGFloat)damping
              initialSpringVelocity:(CGFloat)velocity
                           duration:(CGFloat)duration
{
    
    //60个关键帧
    NSInteger numOfPoints  = duration * 60;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:numOfPoints];
    for (NSInteger i = 0; i < numOfPoints; i++) {
        [values addObject:@(0.0)];
    }
    
    //差值
    CGFloat d_value = [toValue floatValue] - [fromValue floatValue];
    
    for (NSInteger point = 0; point<numOfPoints; point++) {
        
        CGFloat x = (CGFloat)point / (CGFloat)numOfPoints;
        CGFloat value = [toValue floatValue] - d_value * (pow(M_E, -damping * x) * cos(velocity * x)); // y = 1-e^{-5x} * cos(30x)
        //        NSLog(@"toValue:%f,diff:%f",[toValue floatValue],d_value * (pow(M_E, -damping * x) * cos(velocity * x)));
        values[point] = @(value);
    }
    
    return values;
}

+(CGFloat)normalizeAnimationValues:(CGFloat)x
            usingSpringWithDamping:(CGFloat)damping
             initialSpringVelocity:(CGFloat)velocity
{
    return pow(M_E, -damping * x) + cos(velocity * x);
}

@end