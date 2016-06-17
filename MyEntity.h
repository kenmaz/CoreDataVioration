//
//  MyEntity.h
//  CoreDataViolationCrash
//
//  Created by Kentaro Matsumae on 2016/06/17.
//  Copyright © 2016年 kenmaz.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyEntity : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+ (void)fetch;

@end

NS_ASSUME_NONNULL_END

#import "MyEntity+CoreDataProperties.h"
