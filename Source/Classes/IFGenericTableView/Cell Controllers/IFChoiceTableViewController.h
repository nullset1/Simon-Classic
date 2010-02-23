//
//  IFChoiceTableViewController.h
//  Thunderbird
//
//  Created by Craig Hockenberry on 1/29/09.
//  Copyright 2009 The Iconfactory. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IFCellModel.h"

@interface IFChoiceTableViewController : UITableViewController
{
    SEL updateAction;
    id updateTarget;

    NSString *footerNote;

    NSDictionary *choices;
    NSArray *choiceKeys;

    id <IFCellModel> model;
    NSString *key;
}

@property (nonatomic, assign) SEL updateAction;
@property (nonatomic, assign) id updateTarget;

@property (nonatomic, copy) NSString *footerNote;

@property (nonatomic, copy) NSDictionary *choices;
@property (nonatomic, retain) id <IFCellModel> model;
@property (nonatomic, copy) NSString *key;

@end

