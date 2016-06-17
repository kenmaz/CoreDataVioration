//
//  MyEntity+CoreDataProperties.h
//  CoreDataViolationCrash
//
//  Created by Kentaro Matsumae on 2016/06/17.
//  Copyright © 2016年 kenmaz.net. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MyEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *someValue;

@end

NS_ASSUME_NONNULL_END
