//
//  FadeButton.m
//  TiMote
//
//  Created by Michael on 8/19/09.
//  Copyright 2009 Michael Sanders. All rights reserved.
//

#import "FadeButton.h"
#import "Transitions.h"

@implementation FadeButton

@synthesize target;
@synthesize action;

- (void)setTarget:(id)newTarget action:(SEL)newAction
{
    [self setTarget:newTarget];
    [self setAction:newAction];
}

#pragma mark Touch events

- (void)setHighlighted:(BOOL)highlight
{
    [super setHighlighted:highlight];
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setHighlighted:YES];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:[self superview]];
    BOOL containsPoint = CGRectContainsPoint([self frame], point);
    // Visually show cancelled touch if dragged outside of bounds.
    if ([self isHighlighted] && !containsPoint) {
        addFadeTransition([self layer], 0.1f);
        [self setHighlighted:NO];
    }
    // Allow cancelled touch to be dragged back in.
    else if (![self isHighlighted] && containsPoint) {
        [self setHighlighted:YES];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self isHighlighted]) return;

    addFadeTransition([self layer], 0.2f);
    [self setHighlighted:NO];

    // If location was out-of-bounds, cancel button press
    CGPoint point = [[touches anyObject] locationInView:[self superview]];
    if (CGRectContainsPoint([self frame], point)) {
        [target performSelector:action withObject:self];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    addFadeTransition([self layer], 0.1f);
    [self setHighlighted:NO];
}

#pragma mark -

@end
