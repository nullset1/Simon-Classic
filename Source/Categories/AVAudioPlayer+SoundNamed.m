//
//  AVAudioPlayer+SoundNamed.m
//  Simon Asserts
//
//  Created by Michael on 2/9/10.
//  Copyright 2010 Michael Sanders. All rights reserved.
//

#import "AVAudioPlayer+SoundNamed.h"

@implementation AVAudioPlayer (SoundNamed)

- (id)initWithSoundNamed:(NSString *)name
                  ofType:(NSString *)type
                   error:(NSError **)error
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:name
                                                          ofType:type];
    if (soundPath == nil) return nil;

    NSURL *soundURL = [NSURL fileURLWithPath:soundPath isDirectory:NO];
    if (soundURL == nil) return nil;

    return [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:error];
}

@end
