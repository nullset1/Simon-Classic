//
//  AVAudioPlayer+PlayOrRestart.h
//  Simon Classic
//
//  Created by Michael on 2/9/10.
//  Copyright 2010 Michael Sanders. All rights reserved.
//

#import <AvFoundation/AvFoundation.h>

@interface AVAudioPlayer (PlayOrRestart)

// Plays the sound if it is stopped, or restarts it at the beginning if it is
// already playing.
- (void)playOrRestart;

@end
