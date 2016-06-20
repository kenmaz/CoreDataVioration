//
//  EntityA+CoreDataProperties.h
//  CoreDataViolationCrash
//
//  Created by Kentaro Matsumae on 2016/06/20.
//  Copyright © 2016年 kenmaz.net. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "EntityA.h"

NS_ASSUME_NONNULL_BEGIN

@interface EntityA (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *foo;

@end

NS_ASSUME_NONNULL_END
