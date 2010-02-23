//
//  SimonGame.m
//  Simon Classic
//
//  Created by Michael on 2/9/10.
//  Copyright 2010 Michael Sanders.
//

#import "SimonGame.h"
#import "NSTimer+ScheduledTimer.h"
#include "deadbeef_rand.h"

@interface SimonGame (Private)
- (void)reset;
- (void)nextMove;
@end

@implementation SimonGame

@synthesize delegate;
@synthesize gameOver;

+ (void)initialize
{
    // Seed random number generator.
    deadbeef_sranddev();
}

- (id)init
{
    return [self initWithDelegate:nil maxDelay:0.0];
}

// Designated initializer.
- (id)initWithDelegate:(id <SimonGameDelegate>)newDelegate
              maxDelay:(NSTimeInterval)maxDelay
{
    if (self = [super init]) {
        [self setDelegate:newDelegate];
        maxWaitInterval = maxDelay;
        gameState = kSimonGameStateIdle;
        gameOver = YES;
    }
    return self;
}

- (void)startNewGame
{
    [self reset];

    gameOver = NO;
    gameState = kSimonGameStateMachineTurn;
    currentSequence = [[NSMutableArray alloc] initWithCapacity:20];

    // Check to see if we've waited for the user too long every half a second.
	waitTimer = [[NSTimer alloc] initAndScheduleWithTimeInterval:0.5
                                                          target:self
                                                        selector:@selector(checkTimeLimit)
                                                        userInfo:nil
                                                         repeats:YES];

    [self nextMove];
}

- (void)setPlayersTurn
{
    [lastMoveDate release];
    lastMoveDate = [[NSDate alloc] init];

    if (![self gameOver] && gameState != kSimonGameStateIdle) {
        gameState = kSimonGameStatePlayerNeedsToStart;
    }
}

- (void)playerPressedButton:(SimonButtonType)buttonType
{
    if (gameState == kSimonGameStatePlayerNeedsToStart) {
        gameState = kSimonGameStatePlayerGoing;
    }

    // Ignore if it's not the player's turn.
    if (gameState != kSimonGameStatePlayerGoing) {
        DLog(@"It's not your turn!");
        [self forceGameOver];
        return;
    }

    [lastMoveDate release];
    lastMoveDate = [[NSDate alloc] init];

    if ([currentSequence count] <= playerIndex ||
        [[currentSequence objectAtIndex:playerIndex++] charValue] != buttonType) {
        DLog(@"Wrong button!");
        [self forceGameOver];
    } else if (playerIndex == [currentSequence count]) {
        if ([delegate respondsToSelector:@selector(scoreChangedTo:forGame:)]) {
            [delegate scoreChangedTo:playerIndex forGame:self];
        }

        [self nextMove];
    }
}

- (void)checkTimeLimit
{
    NSAssert(![self gameOver], @"Timer called during game over!");

    if (lastMoveDate != nil &&
        gameState == kSimonGameStatePlayerGoing &&
        -[lastMoveDate timeIntervalSinceNow] >= maxWaitInterval) {
        DLog(@"Timed out.");
        [self forceGameOver];
    }
}

#pragma mark Private

- (void)nextMove
{
    NSAssert(currentSequence != nil, @"Sequence is nil!");

    playerIndex = 0;
    SimonButtonType nextButton = DEADBEEF_RANDRANGE(kSimonGreenButton,
                                                    kSimonYellowButton + 1);
    [currentSequence addObject:[NSNumber numberWithChar:nextButton]];

    // Calculate decent wait interval between 800 and 450 milliseconds,
    // depending on the length of the sequence.
    NSTimeInterval decentWaitInterval = 0.8 - ([currentSequence count] * 0.05);
    if (decentWaitInterval < 0.45) decentWaitInterval = 0.45;

    [delegate playSequence:currentSequence
                atInterval:decentWaitInterval
                   forGame:self];

    // Avoid bug where gameover occurs if move took too long.
    [lastMoveDate release];
    lastMoveDate = nil;
}

// Resets game to idle state.
- (void)reset
{
    gameState = kSimonGameStateIdle;

    [currentSequence release];
    currentSequence = nil;

    [waitTimer invalidate];
    [waitTimer release];
    waitTimer = nil;

    [lastMoveDate release];
    lastMoveDate = nil;

    if ([delegate respondsToSelector:@selector(scoreChangedTo:forGame:)]) {
        [delegate scoreChangedTo:0 forGame:self];
    }
}

#pragma mark -

- (void)forceGameOver
{
    const NSUInteger score = playerIndex;

    [self reset];
    gameOver = YES;

    if ([delegate respondsToSelector:@selector(simonGameOver:withScore:)]) {
        [delegate simonGameOver:self withScore:score];
    }
}

- (void)dealloc
{
    [self reset];
    [super dealloc];
}

@end
