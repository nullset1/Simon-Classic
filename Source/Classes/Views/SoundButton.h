//
//  SoundButton.h
//  Simon Classic
//
//  Created by Michael on 2/9/10.
//  Copyright 2010 Michael Sanders.
//

#import <UIKit/UIKit.h>
#import "FadeButton.h"

@class AVAudioPlayer;
@interface SoundButton : FadeButton
{
    AVAudioPlayer *sound;
}

- (void)setSoundToFileInBundle:(NSString *)soundFile
                        ofType:(NSString *)type;
- (void)playSound;
- (void)stopSound;

@end
