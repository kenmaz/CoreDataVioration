//
//  EntityB+CoreDataProperties.h
//  CoreDataViolationCrash
//
//  Created by Kentaro Matsumae on 2016/06/20.
//  Copyright © 2016年 kenmaz.net. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "EntityB.h"

NS_ASSUME_NONNULL_BEGIN

@interface EntityB (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *bar;

@end

NS_ASSUME_NONNULL_END
