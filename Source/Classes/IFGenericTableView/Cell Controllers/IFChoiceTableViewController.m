//
//  IFChoiceTableViewController.m
//  Thunderbird
//
//  Created by Craig Hockenberry on 1/29/09.
//  Copyright 2009 The Iconfactory. All rights reserved.
//

#import "IFChoiceTableViewController.h"
#import "IFNamedImage.h"

@implementation IFChoiceTableViewController

@synthesize updateAction;
@synthesize updateTarget;
@synthesize footerNote;
@synthesize choices;
@synthesize model;
@synthesize key;

- (void)setChoices:(NSDictionary *)newChoices
{
    NSDictionary *copy = [newChoices copy];
    [choices release];
    choices = copy;

    [choiceKeys release];
    choiceKeys = [[choices allKeys] retain];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [choices count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat result = 44.0f;

    NSUInteger row = [indexPath row];
    id choiceKey = [choiceKeys objectAtIndex:row];
    if ([choiceKey isKindOfClass:[IFNamedImage class]]) {
        CGSize imageSize = [[choiceKey image] size];
        if (imageSize.height < 44.0f) {
            result = 44.0f;
        } else {
            result = imageSize.height + 20.0f + 1.0f;
        }
    } else if ([choiceKey isKindOfClass:[UIImage class]]) {
        CGSize imageSize = [choiceKey size];
        result = imageSize.height + 20.0f + 1.0f;
    }

    return result;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return footerNote;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellID = @"ChoiceSelectionCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero
                                       reuseIdentifier:cellID] autorelease];
    }

    NSUInteger row = [indexPath row];
    id choiceKey = [choiceKeys objectAtIndex:row];

    UILabel *textLabel = [cell textLabel];
    UIImageView *imageView = [cell imageView];
    if ([choiceKey isKindOfClass:[NSString class]]) {
        [textLabel setText:choiceKey];
        [imageView setImage:nil];
    } else if ([choiceKey isKindOfClass:[IFNamedImage class]]) {
        UIImage *image = [choiceKey image];
        CGSize imageSize = [image size];

        [imageView setImage:image];
        [textLabel setText:imageSize.width < 44.0f ? [choiceKey name] : nil];
    } else {
        [imageView setImage:[choiceKey isKindOfClass:[UIImage class]] ? choiceKey : nil];
        [textLabel setText:nil];
    }

    BOOL checked = [[choices objectForKey:choiceKey] isEqual:[model objectForKey:key]];
    [cell setAccessoryType:checked ? UITableViewCellAccessoryCheckmark
                                   : UITableViewCellAccessoryNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];

    // Tell the model our row has been checked.
    id choiceKey = [choiceKeys objectAtIndex:row];
    [model setObject:[choices objectForKey:choiceKey] forKey:key];

    // Notify the target we have been updated.
    if (updateTarget != nil &&
        [updateTarget respondsToSelector:updateAction]) {
        [updateTarget performSelector:updateAction withObject:tableView];
    }

    // Actually check the row.
    for (NSIndexPath *visibleIndexPath in [tableView indexPathsForVisibleRows]) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:visibleIndexPath];
        BOOL checked = [visibleIndexPath row] == row;
        [cell setAccessoryType:checked ? UITableViewCellAccessoryCheckmark
                                       : UITableViewCellAccessoryNone];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dealloc
{
    [choices release];
    [choiceKeys release];
    [model release];
    [key release];
    [footerNote release];
    [super dealloc];
}

@end

