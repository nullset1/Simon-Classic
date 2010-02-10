//
//  SoundButton.m
//  Simon Asserts
//
//  Created by Michael on 2/9/10.
//  Copyright 2010 Michael Sanders. All rights reserved.
//

#import "SoundButton.h"
#import "AVAudioPlayer+SoundNamed.h"
#import "AVAudioPlayer+PlayOrRestart.h"

@implementation SoundButton

- (void)setSoundToFileInBundle:(NSString *)soundFile
                        ofType:(NSString *)type
{
    // Create the new sound.
    [sound release];
    sound = [[AVAudioPlayer alloc] initWithSoundNamed:soundFile
                                               ofType:type
                                                error:NULL];
}

- (void)playSound
{
    [sound playOrRestart];
}

- (void)stopSound
{
    if ([sound isPlaying]) {
        [sound pause];
        [sound setCurrentTime:0.0];
    }
}

- (void)dealloc
{
    [sound release];
    [super dealloc];
}

@end
