//
//  SoundButton.m
//  Simon Classic
//
//  Created by Michael on 2/9/10.
//  Copyright 2010 Michael Sanders.
//

#import "SoundButton.h"
#import "LosslessSound.h"

@implementation SoundButton

- (void)setSoundToFileInBundle:(NSString *)soundFile ofType:(NSString *)type
{
    [self removeSound];

    // Create the new sound.
    sound = [[LosslessSound alloc] initWithSoundNamed:soundFile
                                               ofType:type];
    if (sound == nil) {
        NSLog(@"Could not load sound file: %@", soundFile);
    }
}

- (void)playSound
{
    [sound play];
}

- (void)removeSound
{
    [sound release];
    sound = nil;
}

- (void)dealloc
{
    [self removeSound];
    [super dealloc];
}

@end
