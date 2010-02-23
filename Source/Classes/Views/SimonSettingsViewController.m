//
//  SettingsViewController.m
//  Simon Classic
//
//  Created by Michael on 2/20/10.
//  Copyright 2010 Michael Sanders. All rights reserved.
//

#import "SimonSettingsViewController.h"
#import "IFChoiceCellController.h"
#import "SimonViewController.h" // For sound keys; nothing else.
#import "SoundPrefKeys.h"
#import "GameOverSounds.h"

@implementation SimonSettingsViewController

- (void)constructTableGroups
{
    // Here I have changed IFChoiceCellController to accept a dictionary
    // instead of an NSArray, because that was much more convenient (else I
    // would need to hard-code array indexes).
    //
    // The keys serve as the description, and the values serve as the value to
    // be written to the model when the row is selected.
    //
    // So, when "Marimba" is selected here, NSUserDefaults will suddenly notice
    // its simonSoundSetKey changed to kSimonButtonSoundSetMarimba.
    NSString *buttonSoundsTitle = NSLocalizedString(@"ButtonSounds", nil);
    NSDictionary *buttonSounds =
        [[NSDictionary alloc] initWithObjectsAndKeys:kSimonButtonSoundSetDefault,
                                                     NSLocalizedString(@"Default", nil),
                                                     kSimonButtonSoundSetMarimba,
                                                     NSLocalizedString(@"Marimba", nil), nil];
    IFChoiceCellController *buttonSoundsCell =
        [[IFChoiceCellController alloc] initWithLabel:buttonSoundsTitle
                                           andChoices:buttonSounds
                                                atKey:simonSoundSetKey
                                              inModel:model];
    [buttonSounds release];

    NSString *gameOverSoundTitle = NSLocalizedString(@"GameOverSound", nil);
    NSDictionary *gameOverSounds =
        [[NSDictionary alloc] initWithObjectsAndKeys:kGameOverSoundVortex,
                                                     NSLocalizedString(@"Vortex", nil),
                                                     kGameOverSoundSadTrombone,
                                                     NSLocalizedString(@"SadTrombone", nil),
                                                     kGameOverSoundLosingHorns,
                                                     NSLocalizedString(@"LosingHorns", nil), nil];
    IFChoiceCellController *gameOverSoundCell =
        [[IFChoiceCellController alloc] initWithLabel:gameOverSoundTitle
                                           andChoices:gameOverSounds
                                                atKey:gameOverSoundKey
                                              inModel:model];
    [gameOverSounds release];

    NSArray *group1 = [[NSArray alloc] initWithObjects:buttonSoundsCell,
                                                       gameOverSoundCell, nil];
    [buttonSoundsCell release];
    [gameOverSoundCell release];

    // Define the sections for the table view.
    NSArray *groups = [[NSArray alloc] initWithObjects:group1, nil];
    [group1 release];
    [self setTableGroups:groups];
    [groups release];

    // Define the headers for the sections.
    NSString *soundsTitle = NSLocalizedString(@"Sounds", nil);
    NSArray *headers = [[NSArray alloc] initWithObjects:soundsTitle, nil];
    [self setTableHeaders:headers];
    [headers release];
}

@end
