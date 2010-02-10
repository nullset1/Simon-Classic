//
//  UIButton+TapButton.h
//  Simon Asserts
//
//  Created by Michael on 2/9/10.
//  Copyright 2010 Michael Sanders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FadeButton.h"

@interface FadeButton (TapButton)

// Visually and asynchronously taps button (but does not invoke action) for
// given interval.
- (void)visuallyTapFor:(NSTimeInterval)tapDelay
          fadeOutDelay:(CGFloat)fadeOutDelay;

@end
