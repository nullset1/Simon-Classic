//
//  SoundButton.h
//  Simon Classic
//
//  Created by Michael on 2/9/10.
//  Copyright 2010 Michael Sanders.
//

#import <UIKit/UIKit.h>
#import "FadeButton.h"

@class LosslessSound;
@interface SoundButton : FadeButton
{
    LosslessSound *sound;
}

- (void)setSoundToFileInBundle:(NSString *)soundFile ofType:(NSString *)type;
- (void)playSound;
- (void)removeSound;

@end
