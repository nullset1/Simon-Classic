//
//  AppController.m
//  Simon Asserts
//
//  Created by Michael on 2/8/10.
//  Copyright Michael Sanders 2010. All rights reserved.
//

#import "AppController.h"
#import "SimonGame.h"
#import "SoundButton.h"
#import "FadeButton+TapButton.h"
#import "AVAudioPlayer+SoundNamed.h"
#import "AVAudioPlayer+PlayOrRestart.h"
#import "FlurryAPI.h"

NSString * const highscoreKey = @"HighScore";

@implementation AppController

@synthesize currentScoreLabel;
@synthesize bestScoreLabel;

@synthesize greenButton;
@synthesize redButton;
@synthesize blueButton;
@synthesize yellowButton;

- (void)awakeFromNib
{
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [self setHighScore:[userDefaults integerForKey:highscoreKey]];

    [greenButton setHighlightedImage:[UIImage imageNamed:@"green-lit.png"]];
    [greenButton setSoundToFileInBundle:@"green" ofType:@"m4a"];

    [redButton setHighlightedImage:[UIImage imageNamed:@"red-lit.png"]];
    [redButton setSoundToFileInBundle:@"red" ofType:@"m4a"];

    [blueButton setHighlightedImage:[UIImage imageNamed:@"blue-lit.png"]];
    [blueButton setSoundToFileInBundle:@"blue" ofType:@"m4a"];

    [yellowButton setHighlightedImage:[UIImage imageNamed:@"yellow-lit.png"]];
    [yellowButton setSoundToFileInBundle:@"yellow" ofType:@"m4a"];

    buttons = [[NSArray alloc] initWithObjects:greenButton, redButton,
                                               blueButton, yellowButton, nil];

    for (SoundButton *button in buttons) {
        [button setTarget:self action:@selector(tappedButton:)];
    }

    gameOverSound = [[AVAudioPlayer alloc] initWithSoundNamed:@"gameover"
                                                       ofType:@"m4a"
                                                        error:NULL];

    simonGame = [[SimonGame alloc] initWithDelegate:self maxDelay:5.0];
    [simonGame startNewGame];

    // Initialize Flurry analytics tracker.
    [FlurryAPI startSession:@"6X2WL9TTRI9WDP1GVTLP"];
}

- (void)dealloc
{
    [gameOverSound release];
    [simonGame release];
    [buttons release];
    [super dealloc];
}

- (void)setHighScore:(NSUInteger)newScore
{
    highscore = newScore;

    static NSString *highscoreWord = nil;
    if (highscoreWord == nil) {
        highscoreWord = NSLocalizedString(@"Best", nil);
    }

    NSString *bestScoreText =
        [[NSString alloc] initWithFormat:@"%@: %d", highscoreWord, highscore];
    [bestScoreLabel setText:bestScoreText];
    [bestScoreText release];
}

- (SoundButton *)simonButtonOfType:(SimonButtonType)buttonType
{
    switch (buttonType) {
        case kSimonGreenButton:
            return greenButton;
        case kSimonRedButton:
            return redButton;
        case kSimonBlueButton:
            return blueButton;
        case kSimonYellowButton:
            return yellowButton;
        default:
            return nil;
    }
}

#pragma mark UIApplication delegate

- (void)applicationWillTerminate:(UIApplication *)app
{
    DLog(@"Saving highscore for next time.");
    [[NSUserDefaults standardUserDefaults] setInteger:highscore
                                               forKey:highscoreKey];

    // Log high score to Flurry.
    NSNumber *theScore = [NSNumber numberWithUnsignedInteger:highscore];
    NSDictionary *parameters =
        [[NSDictionary alloc] initWithObjectsAndKeys:theScore, @"score", nil];
    [FlurryAPI logEvent:@"Highscore" withParameters:parameters];
    [parameters release];
}

#pragma mark -

#pragma mark SoundButton actions

- (IBAction)tappedButton:(SoundButton *)button
{
    SimonButtonType buttonType = 0;

    if (button == greenButton) {
        buttonType = kSimonGreenButton;
    } else if (button == redButton) {
        buttonType = kSimonRedButton;
    } else if (button == blueButton) {
        buttonType = kSimonBlueButton;
    } else if (button == yellowButton) {
        buttonType = kSimonYellowButton;
    }

    [simonGame playerPressedButton:buttonType];

    if (![simonGame gameOver]) [button playSound];
}

#pragma mark -

- (void)setButtonsEnabled:(BOOL)enable
{
    for (SoundButton *button in buttons) {
        [button setUserInteractionEnabled:enable];
    }
}

- (void)finishPlayingSequenceForGame:(SimonGame *)game
{
    [game setPlayersTurn];
    [self setButtonsEnabled:YES];
}

#pragma mark SimonGame delegate

- (void)playSequence:(NSArray *)sequence
          atInterval:(NSTimeInterval)waitInterval
             forGame:(SimonGame *)game
{
    [self setButtonsEnabled:NO];

    NSTimeInterval nextInterval = waitInterval;
    nextInterval += 0.8; // Pause a little before starting.

    for (NSNumber *buttonNumber in sequence) {
        SimonButtonType buttonType = [buttonNumber charValue];
        SoundButton *button = [self simonButtonOfType:buttonType];

        [self performSelector:@selector(tapSimonButton:)
                   withObject:button
                   afterDelay:nextInterval];
        nextInterval += waitInterval;
    }

    [self performSelector:@selector(finishPlayingSequenceForGame:)
               withObject:game
               afterDelay:nextInterval - waitInterval];
}

// Visually tap and plays sound for given simon button only if the game is
// not over.
- (void)tapSimonButton:(SoundButton *)button
{
    if (![simonGame gameOver]) {
        [button playSound];
        [button visuallyTapFor:0.3 fadeOutDelay:0.2f];
    }
}

- (void)scoreChangedTo:(NSUInteger)newScore
               forGame:(SimonGame *)game
{
    static NSString *scoreWord = nil;
    if (scoreWord == nil) {
        scoreWord = NSLocalizedString(@"Score", nil);
    }

    NSString *newScoreText =
        [[NSString alloc] initWithFormat:@"%@: %d", scoreWord, newScore];
    [currentScoreLabel setText:newScoreText];
    [newScoreText release];

    if (newScore > highscore) {
        [self setHighScore:newScore];
    }
}

- (void)simonGameOver:(SimonGame *)game
            withScore:(NSUInteger)score
{
    DLog(@"Game over...");
    DLog(@"We got %d point(s)!", score);

    // Tap all buttons at once.
    for (SoundButton *button in buttons) {
        [button visuallyTapFor:0.5 fadeOutDelay:1.0f];
        [button stopSound];
    }

    [gameOverSound playOrRestart];

    // Start a new game in 3 seconds.
    if (!gamePending) {
        [self setButtonsEnabled:NO];
        [self performSelector:@selector(restartGame:)
                   withObject:game
                   afterDelay:3.0];
        gamePending = YES; // Avoid inadvertently starting multiple games.
    }

    // Log score to flurry.
    NSNumber *theScore = [NSNumber numberWithUnsignedInteger:score];
    NSDictionary *parameters =
        [[NSDictionary alloc] initWithObjectsAndKeys:theScore, @"score", nil];
    [FlurryAPI logEvent:@"Game Over" withParameters:parameters];
    [parameters release];
}

#pragma mark -

- (void)restartGame:(SimonGame *)game
{
    gamePending = NO;
    [game startNewGame];
}

@end
