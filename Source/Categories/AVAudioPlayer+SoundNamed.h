//
//  AVAudioPlayer+SoundNamed.h
//  Simon Asserts
//
//  Created by Michael on 2/9/10.
//  Copyright 2010 Michael Sanders. All rights reserved.
//

#import <AvFoundation/AvFoundation.h>

@interface AVAudioPlayer (SoundNamed)

// Returns sound file of the given name in the main bundle, or nil if it is
// not found or an error occurs.
- (id)initWithSoundNamed:(NSString *)name 
                  ofType:(NSString *)type 
                   error:(NSError **)error;

@end
