//
//  UIButton+TapButton.h
//  Simon Classic
//
//  Created by Michael on 2/9/10.
//  Copyright 2010 Michael Sanders.
//

#import <UIKit/UIKit.h>
#import "FadeButton.h"

@interface FadeButton (TapButton)

// Visually and asynchronously taps button (but does not invoke action) for
// given interval.
- (void)visuallyTapFor:(NSTimeInterval)tapDelay
          fadeOutDelay:(CGFloat)fadeOutDelay;

@end
