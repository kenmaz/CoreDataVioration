//
//  AppDelegate.m
//  CoreDataViolationCrash
//
//  Created by Kentaro Matsumae on 2016/06/17.
//  Copyright © 2016年 kenmaz.net. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataStack.h"
#import <MagicalRecord/MagicalRecord.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [CoreDataStack setup];
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"mr"];
    
    return YES;
}

@end
