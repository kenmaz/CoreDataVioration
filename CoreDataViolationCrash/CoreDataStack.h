//
//  CoreDataStack.h
//  CoreDataViolationCrash
//
//  Created by Kentaro Matsumae on 2016/06/17.
//  Copyright © 2016年 kenmaz.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataStack : NSObject
+ (void)setup;
+ (NSManagedObjectContext*)mainContext;
+ (NSManagedObjectContext*)privateContext;
@end
