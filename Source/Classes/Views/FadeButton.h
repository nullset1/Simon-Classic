//
//  FadeButton.h
//  TiMote
//
//  Created by Michael on 8/19/09.
//  Copyright 2009 Michael Sanders.
//

#import <UIKit/UIKit.h>

// UIButton is tough to subclass and a bit overkill for my needs, so I created
// this simple generic button class. It is essentially equivalent to a UIButton
// with only one target & action that is sent on UIControlEventTouchUpInside.
@interface FadeButton : UIImageView
{
    id target; // Weak reference.
    SEL action;
}

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

// Convenience method.
- (void)setTarget:(id)target action:(SEL)action;

@end
