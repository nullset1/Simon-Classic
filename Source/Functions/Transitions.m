//
//  Transitions.m
//  Simon Asserts
//
//  Created by Michael on 2/9/10.
//  Copyright 2010 Michael Sanders. All rights reserved.
//

#import "Transitions.h"

inline void addFadeTransition(CALayer *layer, CGFloat duration)
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:duration];
    [animation setType:kCATransitionFade];
    [layer addAnimation:animation forKey:kCATransitionFade];
}
