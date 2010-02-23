//
//  LosslessSound.h
//  Simon Classic
//
//  Created by Michael on 2/23/10.
//  Copyright 2010 Michael Sanders. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <Foundation/Foundation.h>

// Only works with short (30 seconds or less) sounds in linear PCM or IMA4
// (IMA/ADPCM) format (.caf, .aif, or .wav files).
@interface LosslessSound : NSObject
{
    SystemSoundID soundID;
}

// Attempts to create sound file from the given URL.
- (id)initWithURL:(NSURL *)url;

// Returns sound file of the given name in the main bundle, or nil if it is
// not found or an error occurs.
- (id)initWithSoundNamed:(NSString *)name ofType:(NSString *)type;

// Plays the sound asynchronously and immediately returns. 
- (void)play;

@end
