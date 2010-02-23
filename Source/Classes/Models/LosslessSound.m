//
//  LosslessSound.m
//  Simon Classic
//
//  Created by Michael on 2/23/10.
//  Copyright 2010 Michael Sanders. All rights reserved.
//

#import "LosslessSound.h"

@implementation LosslessSound

// Designated initializer.
- (id)initWithURL:(NSURL *)url
{
    if (self = [super init]) {
        if (AudioServicesCreateSystemSoundID((CFURLRef)url,
                                             &soundID) != noErr) {
            AudioServicesDisposeSystemSoundID(soundID);
            return nil;
        }
    }

    return self;
}

- (id)initWithSoundNamed:(NSString *)name ofType:(NSString *)type
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:name
                                                          ofType:type];
    if (soundPath == nil) return nil;

    NSURL *soundURL = [NSURL fileURLWithPath:soundPath isDirectory:NO];
    if (soundURL == nil) return nil;

    return [self initWithURL:soundURL];
}

- (void)play
{
    AudioServicesPlaySystemSound(soundID);
}

- (void)dealloc
{
    AudioServicesDisposeSystemSoundID(soundID);
    [super dealloc];
}

@end
