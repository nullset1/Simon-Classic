//
//  SoundButton.m
//  Simon Classic
//
//  Created by Michael on 2/9/10.
//  Copyright 2010 Michael Sanders.
//

#import "SoundButton.h"
#import "AVAudioPlayer+SoundNamed.h"
#import "AVAudioPlayer+PlayOrRestart.h"

@implementation SoundButton

- (void)removeSound
{
    [sound release];
    sound = nil;
}

- (void)setSoundToFileInBundle:(NSString *)soundFile
                        ofType:(NSString *)type
{
    [self removeSound];

    // Create the new sound.
    NSError *error = nil;
    sound = [[AVAudioPlayer alloc] initWithSoundNamed:soundFile
                                               ofType:type
                                                error:&error];
    if (sound == nil) {
        NSLog(@"Could not load sound: %@", error);
    }
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
