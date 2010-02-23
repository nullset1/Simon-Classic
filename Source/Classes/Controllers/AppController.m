//
//  AppController.m
//  Simon Classic
//
//  Created by Michael on 2/8/10.
//  Copyright Michael Sanders 2010.
//

#import "AppController.h"
#import "SimonGame.h"
#import "FadeButton+TapButton.h"
#import "LosslessSound.h"
#import "FlurryAPI.h"
#import "SimonViewController.h"
#import "SoundPrefKeys.h"
#import "GameOverSounds.h"

NSString * const highscoreKey = @"HighScore";

@implementation AppController

- (void)applicationDidFinishLaunching:(UIApplication *)app
{
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    simonViewController = [[SimonViewController alloc] init];
    [simonViewController setDelegate:self];

    navController =
        [[UINavigationController alloc] initWithRootViewController:simonViewController];
    [simonViewController release];

    [navController setNavigationBarHidden:YES];
	[window addSubview:[navController view]];
    [window makeKeyAndVisible];

    [app setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];

    simonGame = [[SimonGame alloc] initWithDelegate:self maxDelay:5.0];
    [self setButtonsEnabled:NO];

    // Initialize Flurry analytics tracker.
    [FlurryAPI startSession:@"6X2WL9TTRI9WDP1GVTLP"];
}

- (void)dealloc
{
    [gameOverSound release];
    [simonGame release];
    [navController release];
    [window release];
    [super dealloc];
}

- (void)reloadSounds
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    DLog(@"Loading sounds from the user defaults");

    // Configure button sounds.
    NSString *soundSet = [userDefaults stringForKey:simonSoundSetKey];
    if (soundSet == nil) {
        soundSet = kSimonButtonSoundSetDefault;
        [userDefaults setObject:soundSet forKey:simonSoundSetKey];
    }
    [simonViewController setSimonButtonSoundSet:soundSet];

    // Configure game over sound.
    [gameOverSound release];
    gameOverSound = nil;

    NSString *gameOverSoundName = [userDefaults stringForKey:gameOverSoundKey];
    if (gameOverSoundName == nil) {
        gameOverSoundName = kGameOverSoundSadTrombone;
        [userDefaults setObject:gameOverSoundName forKey:gameOverSoundKey];
    }

    gameOverSound = [[LosslessSound alloc] initWithSoundNamed:gameOverSoundName
                                                       ofType:@"caf"];
    if (gameOverSound == nil) {
        NSLog(@"Could not load sound %@: %@", gameOverSoundName);
    }
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
    [[simonViewController bestScoreLabel] setText:bestScoreText];
    [bestScoreText release];
}

- (SoundButton *)simonButtonOfType:(SimonButtonType)buttonType
{
    switch (buttonType) {
        case kSimonGreenButton:
            return [simonViewController greenButton];
        case kSimonRedButton:
            return [simonViewController redButton];
        case kSimonBlueButton:
            return [simonViewController blueButton];
        case kSimonYellowButton:
            return [simonViewController yellowButton];
        default:
            return nil;
    }
}

#pragma mark UIApplication delegate

- (void)applicationWillTerminate:(UIApplication *)app
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    DLog(@"Saving highscore for next time.");
    [userDefaults setInteger:highscore forKey:highscoreKey];

    // Log high score to Flurry.
    NSNumber *theScore = [NSNumber numberWithUnsignedInteger:highscore];
    NSDictionary *parameters =
        [[NSDictionary alloc] initWithObjectsAndKeys:theScore, @"score", nil];
    [FlurryAPI logEvent:@"Highscore" withParameters:parameters];
    [parameters release];

    // Log sound preferences to Flurry.
    NSString *buttonSoundSet = [userDefaults stringForKey:simonSoundSetKey];
    NSString *gameOverSoundName = [userDefaults stringForKey:gameOverSoundKey];
    parameters =
        [[NSDictionary alloc] initWithObjectsAndKeys:gameOverSoundName,
                                                     @"Gameover Sound",
                                                     buttonSoundSet,
                                                     @"Button Soundset", nil];
    [FlurryAPI logEvent:@"Sounds" withParameters:parameters];
    [parameters release];
}

#pragma mark -

#pragma mark SimonViewController delegate

- (void)simonViewControllerReady:(SimonViewController *)controller
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [self setHighScore:[userDefaults integerForKey:highscoreKey]];
    [self reloadSounds];

    UIBarButtonItem *playButton = [controller playButton];
    [playButton setTarget:self];
    [playButton setAction:@selector(tappedPlayPauseButton:)];
}

- (void)settingsChanged
{
    [self reloadSounds];
}

- (IBAction)tappedSimonButton:(SoundButton *)button
{
    SimonButtonType buttonType = 0;

    if (button == [simonViewController greenButton]) {
        buttonType = kSimonGreenButton;
    } else if (button == [simonViewController redButton]) {
        buttonType = kSimonRedButton;
    } else if (button == [simonViewController blueButton]) {
        buttonType = kSimonBlueButton;
    } else if (button == [simonViewController yellowButton]) {
        buttonType = kSimonYellowButton;
    }

    [simonGame playerPressedButton:buttonType];

    if (![simonGame gameOver]) [button playSound];
}

#pragma mark -

- (void)tappedPlayPauseButton:(UIBarButtonItem *)button
{
    if ([simonGame gameOver]) {
        [button setTitle:NSLocalizedString(@"GiveUp", nil)];
        [simonGame startNewGame];
    } else {
        [simonGame forceGameOver]; // Title to be changed by delegate method.
    }
}

// Enable/disable all Simon buttons.
- (void)setButtonsEnabled:(BOOL)enable
{
    for (SoundButton *button in [simonViewController simonButtons]) {
        [button setUserInteractionEnabled:enable];
    }
}

- (void)finishPlayingSequenceForGame:(SimonGame *)game
{
    if (![game gameOver]) {
        [game setPlayersTurn];
        [self setButtonsEnabled:YES];
    }
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
    [[simonViewController currentScoreLabel] setText:newScoreText];
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
    for (SoundButton *button in [simonViewController simonButtons]) {
        [button visuallyTapFor:0.5 fadeOutDelay:1.0f];
    }

    [gameOverSound play];

    // Allow a new game in 3 seconds.
    if (!gamePending) {
        [self setButtonsEnabled:NO];

        UIBarButtonItem *playButton = [simonViewController playButton];
        [playButton setEnabled:NO];
        [playButton setTitle:NSLocalizedString(@"Play", nil)];

        [self performSelector:@selector(allowNewGame)
                   withObject:nil
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

- (void)allowNewGame
{
    [[simonViewController playButton] setEnabled:YES];
    gamePending = NO;
}

@end
