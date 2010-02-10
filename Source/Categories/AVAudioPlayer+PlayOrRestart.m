//
//  AVAudioPlayer+PlayOrRestart.m
//  Simon Classic
//
//  Created by Michael on 2/9/10.
//  Copyright 2010 Michael Sanders. All rights reserved.
//

#import "AVAudioPlayer+PlayOrRestart.h"

@implementation AVAudioPlayer (PlayOrRestart)

- (void)playOrRestart
{
    if ([self isPlaying]) {
        [self pause];
        [self setCurrentTime:0.0];
    }

    [self play];
}

@end
