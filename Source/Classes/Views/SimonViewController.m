//
//  SimonViewController.m
//  Simon Classic
//
//  Created by Michael on 2/20/10.
//  Copyright 2010 Michael Sanders. All rights reserved.
//

#import "SimonViewController.h"
#import "SimonSettingsViewController.h"
#import "UIViewController+ModalToolbar.h"
#import "IFPreferencesModel.h"

NSString * const kSimonButtonSoundSetDefault = @"Default";
NSString * const kSimonButtonSoundSetMarimba = @"Marimba";

@implementation SimonViewController
@synthesize delegate;

@synthesize simonButtons;
@synthesize greenButton;
@synthesize redButton;
@synthesize blueButton;
@synthesize yellowButton;

@synthesize currentScoreLabel;
@synthesize bestScoreLabel;
@synthesize settingsButton;
@synthesize playButton;

- (id)init
{
    return [super initWithNibName:@"Simon" bundle:nil];
}

- (void)viewDidLoad
{
    [greenButton setHighlightedImage:[UIImage imageNamed:@"green-lit.png"]];
    [redButton setHighlightedImage:[UIImage imageNamed:@"red-lit.png"]];
    [blueButton setHighlightedImage:[UIImage imageNamed:@"blue-lit.png"]];
    [yellowButton setHighlightedImage:[UIImage imageNamed:@"yellow-lit.png"]];

    [settingsButton setTitle:NSLocalizedString(@"Settings", nil)];
    [playButton setTitle:NSLocalizedString(@"NewGame", nil)];

    simonButtons = [[NSArray alloc] initWithObjects:greenButton,
                                                    redButton,
                                                    blueButton,
                                                    yellowButton, nil];
    for (SoundButton *button in simonButtons) {
        [button setTarget:self action:@selector(tappedSimonButton:)];
    }

    if ([delegate respondsToSelector:@selector(simonViewControllerReady:)]) {
        [delegate simonViewControllerReady:self];
    }
}

- (void)dealloc
{
    [simonButtons release];
    [super dealloc];
}

#pragma mark UIBarButtonItem Actions

- (IBAction)showSettings:(id)sender
{
    SimonSettingsViewController *simonSettingsViewController =
        [[SimonSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [simonSettingsViewController setTitle:[settingsButton title]];

    // A wrapper around NSUserDefaults that sets key based on the user input we
    // may receive.
    IFPreferencesModel *settingsModel = [IFPreferencesModel preferencesModel];
    [simonSettingsViewController setModel:settingsModel];

    NSString *backButtonName = NSLocalizedString(@"Back", nil);
    [self presentModalViewControllerWithToolbar:simonSettingsViewController
                                       animated:YES
                                 backButtonName:backButtonName];
    [simonSettingsViewController release];
}

#pragma mark -

#pragma mark UINavigationController delegate

// Called by the UINavigationController that presents the setting
// view controller.
//
// TODO: Is there a cleaner way (e.g. a delegate method or notification) to do this?
- (void)dismissModalViewControllerAnimated:(BOOL)animated
{
    [super dismissModalViewControllerAnimated:animated];

    // We are just going to assume that the view controller dismissed was the
    // settings pane, since that is all that gets presented by us.
    if ([delegate respondsToSelector:@selector(settingsChanged)]) {
        [delegate settingsChanged];
    }
}

#pragma mark -

#pragma mark Sounds

- (void)setSoundsOfPrefix:(NSString *)prefix
{
    [greenButton setSoundToFileInBundle:[prefix stringByAppendingString:@"green"]
                                 ofType:@"mp3"];
    [redButton setSoundToFileInBundle:[prefix stringByAppendingString:@"red"]
                               ofType:@"mp3"];
    [blueButton setSoundToFileInBundle:[prefix stringByAppendingString:@"blue"]
                                ofType:@"mp3"];
    [yellowButton setSoundToFileInBundle:[prefix stringByAppendingString:@"yellow"]
                                  ofType:@"mp3"];
}

- (void)setSimonButtonSoundSet:(NSString *)soundSet
{
    if ([soundSet isEqualToString:kSimonButtonSoundSetDefault]) {
        DLog(@"Using default soundset");
        [self setSoundsOfPrefix:@"default_"];
    } else if ([soundSet isEqualToString:kSimonButtonSoundSetMarimba]) {
        DLog(@"Using marimba soundset");
        [self setSoundsOfPrefix:@"marimba_"];
    } else {
        DLog(@"Unrecognized soundset; removing sound");
        [simonButtons makeObjectsPerformSelector:@selector(removeSound)];
    }
}

#pragma mark -

#pragma mark SoundButton action

- (void)tappedSimonButton:(SoundButton *)button
{
    if ([delegate respondsToSelector:@selector(tappedSimonButton:)]) {
        [delegate tappedSimonButton:button];
    }
}

#pragma mark -

@end
