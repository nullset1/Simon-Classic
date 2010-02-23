//
//  AppController.h
//  Simon Classic
//
//  Created by Michael on 2/8/10.
//  Copyright Michael Sanders 2010.
//

#import <UIKit/UIKit.h>
#import "SimonViewController.h"
#import "SimonGame.h"

@class LosslessSound;
@interface AppController : NSObject <UIApplicationDelegate,
                                     SimonViewControllerDelegate,
                                     SimonGameDelegate>
{
    UIWindow *window;
    UINavigationController *navController;
    SimonViewController *simonViewController;

    SimonGame *simonGame;
    NSUInteger highscore;
    BOOL gamePending;
    LosslessSound *gameOverSound;
}

- (IBAction)tappedSimonButton:(SoundButton *)sender;
- (void)setHighScore:(NSUInteger)score;
- (void)setButtonsEnabled:(BOOL)enable;

@end
