//
//  main.m
//  Simon Classic
//
//  Created by Michael on 2/8/10.
//  Copyright Michael Sanders 2010.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    const int retVal = UIApplicationMain(argc, argv, @"UIApplication", @"AppController");
    [pool release];
    return retVal;
}
