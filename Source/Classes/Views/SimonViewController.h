//
//  SimonViewController.h
//  Simon Classic
//
//  Created by Michael on 2/20/10.
//  Copyright 2010 Michael Sanders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundButton.h"

extern NSString * const kSimonButtonSoundSetDefault;
extern NSString * const kSimonButtonSoundSetMarimba;

@class SimonViewController;
@protocol SimonViewControllerDelegate <NSObject>
@optional
// Called when view controller is finished loading.
// Only called once.
- (void)simonViewControllerReady:(SimonViewController *)controller;

// Called when user NSUserDefaults via settings panel.
- (void)settingsChanged;

// Called when user presses any of the simon buttons.
- (void)tappedSimonButton:(SoundButton *)button;
@end

// This is the RootViewController of the Simon Classic app.
@interface SimonViewController : UIViewController
{
    NSArray *simonButtons; // Merely for convenience.

    SoundButton *greenButton;
    SoundButton *redButton;
    SoundButton *blueButton;
    SoundButton *yellowButton;

    UIBarButtonItem *settingsButton;
    UIBarButtonItem *playButton;
    UILabel *currentScoreLabel;
    UILabel *bestScoreLabel;

    id <SimonViewControllerDelegate> delegate;
}

- (id)init;
- (void)setSimonButtonSoundSet:(NSString *)soundSet;
- (IBAction)showSettings:(id)sender;

@property (nonatomic, assign) id <SimonViewControllerDelegate> delegate;

@property (nonatomic, readonly) NSArray *simonButtons;
@property (nonatomic, assign) IBOutlet SoundButton *greenButton;
@property (nonatomic, assign) IBOutlet SoundButton *redButton;
@property (nonatomic, assign) IBOutlet SoundButton *blueButton;
@property (nonatomic, assign) IBOutlet SoundButton *yellowButton;

@property (nonatomic, assign) IBOutlet UILabel *currentScoreLabel;
@property (nonatomic, assign) IBOutlet UILabel *bestScoreLabel;
@property (nonatomic, assign) IBOutlet UIBarButtonItem *settingsButton;
@property (nonatomic, assign) IBOutlet UIBarButtonItem *playButton;

@end
