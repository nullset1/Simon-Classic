//
//  NSTimer+SheduledTimer.h
//  TiMote
//
//  Created by Michael on 8/25/09.
//  Copyright 2009 Michael Sanders.
//

#import <Foundation/Foundation.h>

@interface NSTimer (ScheduledTimer)

// Exactly the same functionality as -timerWithTimeInterval: and
// -scheduledTimerWithTimeInterval:, only not autoreleased.
- (id)initWithTimeInterval:(NSTimeInterval)interval
                    target:(id)target
                  selector:(SEL)selector
                  userInfo:(id)userInfo
                   repeats:(BOOL)repeats;

- (id)initAndScheduleWithTimeInterval:(NSTimeInterval)interval
                               target:(id)target
                             selector:(SEL)selector
                             userInfo:(id)userInfo
                              repeats:(BOOL)repeats;

@end
