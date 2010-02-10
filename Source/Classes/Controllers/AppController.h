//
//  AppController.h
//  Simon Classic
//
//  Created by Michael on 2/8/10.
//  Copyright Michael Sanders 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimonGame.h"

@class FadeButton, SoundButton, AVAudioPlayer;
@interface AppController : NSObject <UIApplicationDelegate, SimonGameDelegate>
{
    UILabel *currentScoreLabel;
    UILabel *bestScoreLabel;

    NSArray *buttons; // Merely for convenience.
    SoundButton *greenButton;
    SoundButton *redButton;
    SoundButton *blueButton;
    SoundButton *yellowButton;

    SimonGame *simonGame;
    NSUInteger highscore;
    BOOL gamePending;
    AVAudioPlayer *gameOverSound;
}

@property (nonatomic, assign) IBOutlet UILabel *currentScoreLabel;
@property (nonatomic, assign) IBOutlet UILabel *bestScoreLabel;

@property (nonatomic, assign) IBOutlet SoundButton *greenButton;
@property (nonatomic, assign) IBOutlet SoundButton *redButton;
@property (nonatomic, assign) IBOutlet SoundButton *blueButton;
@property (nonatomic, assign) IBOutlet SoundButton *yellowButton;

- (IBAction)tappedButton:(SoundButton *)sender;
- (void)setHighScore:(NSUInteger)score;

@end
