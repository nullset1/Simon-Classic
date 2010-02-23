//
//  UIViewController+modalToolbar.m
//  TiMote
//
//  Created by Michael on 9/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+ModalToolbar.h"

@implementation UIViewController (ModalToolbar)

- (void)dismissModalViewControllerAnimated
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)presentModalViewControllerWithToolbar:(UIViewController *)viewController
                                     animated:(const BOOL)animated
                               backButtonName:(NSString *)name
{
    // Wrap modal view controller in a generic UINavigationController in order to
    // show a toolbar with a custom title.
    UINavigationController *modalController = [[UINavigationController alloc]
                                               initWithRootViewController:viewController];

    if (name != nil && [name length] > 0) {
        // Add back button to the toolbar.
        UIBarButtonItem *backButtonItem = [UIBarButtonItem alloc];
        backButtonItem = [backButtonItem initWithTitle:name
                                                 style:UIBarButtonItemStyleBordered
                                                target:self
                                                action:@selector(dismissModalViewControllerAnimated)];
        [[viewController navigationItem] setLeftBarButtonItem:backButtonItem];
        [backButtonItem release];
    }

    [self presentModalViewController:modalController animated:animated];
    [modalController release];
}

@end
