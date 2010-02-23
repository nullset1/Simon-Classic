
//  IFChoiceRowCellController.m
//  Thunderbird
//
//  Created by Craig Hockenberry on 1/29/09.
//  Copyright 2009 The Iconfactory. All rights reserved.
//

#import "IFChoiceCellController.h"
#import "IFControlTableViewCell.h"
#import "IFNamedImage.h"

@implementation IFChoiceCellController

@synthesize updateTarget, updateAction;
@synthesize updateAction;
@synthesize footerNote;
@synthesize indentationLevel;

- (id)initWithLabel:(NSString *)newLabel
         andChoices:(NSDictionary *)newChoices
              atKey:(NSString *)newKey
            inModel:(id <IFCellModel>)newModel;
{
    if (self = [super init]) {
        label = [newLabel retain];
        choices = [newChoices copy];
        key = [newKey retain];
        model = [newModel retain];

        footerNote = nil;

        indentationLevel = 0;
    }

    return self;
}

- (void)dealloc
{
    [label release];
    [choices release];
    [key release];
    [model release];
    [footerNote release];
    [super dealloc];
}

// Show a table of the options.
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewController *tableViewController = (UITableViewController *)[tableView dataSource];

    IFChoiceTableViewController *choiceTableViewController =
        [[IFChoiceTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [choiceTableViewController setTitle:label];
    [choiceTableViewController setChoices:choices];
    [choiceTableViewController setModel:model];
    [choiceTableViewController setKey:key];
    [choiceTableViewController setUpdateTarget:updateTarget];
    [choiceTableViewController setUpdateAction:updateAction];
    [choiceTableViewController setFooterNote:footerNote];
    [[tableViewController navigationController] pushViewController:choiceTableViewController
                                                          animated:YES];
    [choiceTableViewController release];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const cellID = @"ChoiceDataCell";

    IFControlTableViewCell *cell =
        (IFControlTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[IFControlTableViewCell alloc] initWithFrame:CGRectZero
                                             reuseIdentifier:cellID];
        [cell autorelease];
    }

    UILabel *textLabel = [cell textLabel];
    [textLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setIndentationLevel:indentationLevel];

    [textLabel setText:label];

    // NOTE: The documentation states that the indentation width is 10
    // "points". It's more like 20 pixels and changing the property has no
    // effect on the indentation. We'll use 20 here and cross our fingers
    // that this doesn't screw things up in the future.
    CGSize labelSize = [label sizeWithFont:[textLabel font]];
    const CGFloat viewWidth = 255.0f - (labelSize.width + (20.0f * indentationLevel));

    id choiceValue = [model objectForKey:key];
    if (choiceValue == nil) {
        DLog(@"Key %@ has no value in model %@.", key, model);
        return cell;
    }

    NSArray *possibleKeys = [choices allKeysForObject:choiceValue];
    if (possibleKeys == nil || [possibleKeys count] == 0) {
        DLog(@"Value \"%@\" has no keys in possible choices %@", choiceValue, 
                                                                 choices);
        return cell;
    }

    id choice = [possibleKeys objectAtIndex:0];
    if ([choice isKindOfClass:[NSString class]]) {
        CGRect frame = CGRectMake(0.0f, 0.0f, viewWidth, 22.0f);
        UILabel *choiceLabel = [[UILabel alloc] initWithFrame:frame];
        [choiceLabel setText:choice];
        [choiceLabel setTextAlignment:UITextAlignmentRight];
        [choiceLabel setTextColor:[UIColor colorWithRed:0.20f
                                                  green:0.31f
                                                   blue:0.52f
                                                  alpha:1.0f]];
        [choiceLabel setHighlightedTextColor:[UIColor whiteColor]];
        [cell setView:choiceLabel];
        [choiceLabel release];
    } else if ([choice isKindOfClass:[IFNamedImage class]]) {
        CGRect frame = CGRectMake(0.0f, 0.0f, viewWidth, 22.0f);
        UILabel *choiceLabel = [[UILabel alloc] initWithFrame:frame];
        [choiceLabel setText:[choice name]];
        [choiceLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [choiceLabel setBackgroundColor:[UIColor whiteColor]];
        [choiceLabel setHighlightedTextColor:[UIColor whiteColor]];
        [choiceLabel setTextAlignment:UITextAlignmentRight];
        [choiceLabel setTextColor:[UIColor colorWithRed:0.20f
                                                  green:0.31f
                                                   blue:0.52f
                                                  alpha:1.0f]];
        [cell setView:choiceLabel];
        [choiceLabel release];
    }

    return cell;
}

@end
