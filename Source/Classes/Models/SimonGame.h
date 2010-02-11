//
//  SimonGame.h
//  Simon Classic
//
//  Created by Michael on 2/9/10.
//  Copyright 2010 Michael Sanders.
//

#import <Foundation/Foundation.h>

enum {
    kSimonGreenButton = 1,
    kSimonRedButton,
    kSimonBlueButton,
    kSimonYellowButton
};

typedef char SimonButtonType;

typedef enum {
    kSimonGameStateMachineTurn = 0,
    kSimonGameStatePlayerNeedsToStart,
    kSimonGameStatePlayerGoing,
    kSimonGameStateIdle
} SimonGameState;

@class SimonGame;
@protocol SimonGameDelegate <NSObject>

@required

// Notifies delegate the sequence is to be played.
// Interval should be 800 and 450 milliseconds, depending on the
// sequence length.
// When finished, the delegate must call -setPlayersTurn.
- (void)playSequence:(NSArray *)sequence
          atInterval:(NSTimeInterval)interval
             forGame:(SimonGame *)game;

@optional

// Called when the player fails or waits too long.
- (void)simonGameOver:(SimonGame *)game
            withScore:(NSUInteger)score;

// Notifies delegate of new score.
- (void)scoreChangedTo:(NSUInteger)newScore
               forGame:(SimonGame *)game;

@end

@interface SimonGame : NSObject
{
    NSMutableArray *currentSequence;
    NSUInteger playerIndex;
    id <SimonGameDelegate> delegate;
    BOOL gameOver;

    NSTimeInterval maxWaitInterval;
    NSTimer *waitTimer;
    NSDate *lastMoveDate;
    SimonGameState gameState;
}

@property (nonatomic, assign) id <SimonGameDelegate> delegate;
@property (nonatomic, readonly) BOOL gameOver;

// Creates new simon game (but does not start it).
// If |maxDelay| seconds elapse between a move, the player automatically
// loses; set maxWaitInterval to <= 0.0 to allow an infinite interval.
- (id)initWithDelegate:(id <SimonGameDelegate>)delegate
              maxDelay:(NSTimeInterval)maxDelay;

// To be called at the beginning of a new game.
- (void)startNewGame;

// To be called after a sequence is finished playing.
- (void)setPlayersTurn;

// Notifies that the player pressed the given button.
// Ignored if it is not the player's turn.
- (void)playerPressedButton:(SimonButtonType)buttonType;

- (void)forceGameOver;

@end
