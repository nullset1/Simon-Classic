//
//  UIButton+TapButton.m
//  Simon Classic
//
//  Created by Michael on 2/9/10.
//  Copyright 2010 Michael Sanders.
//

#import "FadeButton+TapButton.h"
#import "Transitions.h"

@implementation FadeButton (TapButton)

- (void)visuallyTapFor:(NSTimeInterval)tapDelay
          fadeOutDelay:(CGFloat)fadeOutDelay
{
    [self setHighlighted:YES];
    [self performSelector:@selector(fadeOutButtonWithDelay:)
               withObject:[NSNumber numberWithFloat:fadeOutDelay]
               afterDelay:tapDelay];
}

#pragma mark Private

- (void)fadeOutButtonWithDelay:(NSNumber *)delay
{
    addFadeTransition([self layer], [delay floatValue]);
    [self setHighlighted:NO];
}

#pragma mark -

@end
