//
//  UIViewController+modalToolbar.h
//  TiMote
//
//  Created by Michael on 9/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ModalToolbar)

// Modally presents a UIViewController with its own toolbar and back button.
// Pass nil or @"" to specify no back button is to be used.
- (void)presentModalViewControllerWithToolbar:(UIViewController *)viewController
                                     animated:(BOOL)animated
                               backButtonName:(NSString *)name;

@end
