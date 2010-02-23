//
//  IFPreferencesModel.m
//  Thunderbird
//
//  Created by Craig Hockenberry on 1/30/09.
//  Copyright 2009 The Iconfactory. All rights reserved.
//

#import "IFPreferencesModel.h"

@implementation IFPreferencesModel

+ (id)preferencesModel
{
    return [NSUserDefaults standardUserDefaults]; // Really, this is all we need.
}

- (void)setObject:(id)value forKey:(NSString *)key
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:value forKey:key];
}

- (id)objectForKey:(NSString *)key
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	return [userDefaults objectForKey:key];
}

@end
