//
//  ViewController.m
//  CoreDataViolationCrash
//
//  Created by Kentaro Matsumae on 2016/06/17.
//  Copyright © 2016年 kenmaz.net. All rights reserved.
//

#import "ViewController.h"
#import "EntityA.h"
#import "EntityB.h"
#import "CoreDataStack.h"
#import "MagicalRecord.h"

@implementation ViewController

- (IBAction)buttonDidTap:(id)sender {
    [self execCoreData];
}

- (void)useMagicalRecord {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        EntityA* entA = [EntityA MR_createEntityInContext:localContext];
        entA.foo = @"aaa";
    }];
    
    NSManagedObjectContext* mainContext = [NSManagedObjectContext MR_defaultContext];
    EntityB* entB = [EntityB MR_findFirstInContext:mainContext];
    if (entB == nil) {
        entB = [EntityB MR_createEntityInContext:mainContext];
        entB.bar = @"bbb";
        [entB.managedObjectContext MR_saveToPersistentStoreAndWait];
    }
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"foo = %@", entB.bar];
    NSArray* entAs = [EntityA MR_findAllWithPredicate:pred inContext:mainContext];
    [EntityA MR_findAllSortedBy:@"foo" ascending:NO withPredicate:pred inContext:mainContext];
    NSLog(@"%zd", entAs.count);
}

- (void)execCoreData {

    // insert EntityA
    
    NSManagedObjectContext* privateContext = [CoreDataStack privateContext];
    [privateContext performBlock:^{
        NSEntityDescription* entADesc = [NSEntityDescription entityForName:@"EntityA" inManagedObjectContext:privateContext];
        EntityA* entA = [[EntityA alloc] initWithEntity:entADesc insertIntoManagedObjectContext:privateContext];
        entA.foo = @"aaa";
        
        NSError* error = nil;
        [privateContext save:&error];
        NSLog(@"1. save:%@ %@", privateContext, error);
        
        NSManagedObjectContext* parentContext = privateContext.parentContext;
        [parentContext performBlock:^{
            NSError* error = nil;
            [parentContext save:&error];
            NSLog(@"2. save:%@ %@", parentContext, error);
        }];
    }];
    
    NSManagedObjectContext* mainContext = [CoreDataStack mainContext];
    
    // fetch EntityB
    NSString* entBBar = nil;
    {
        NSFetchRequest* req = [NSFetchRequest fetchRequestWithEntityName:@"EntityB"];
        NSError* error = nil;
        NSArray* results = [mainContext executeFetchRequest:req error:&error];
        NSLog(@"3. result:%zd", results.count);
        
        if (results.count > 0) {
            EntityB* entB = results[0];
            entBBar = entB.bar;
            
        } else {
            NSEntityDescription* entBDesc = [NSEntityDescription entityForName:@"EntityB" inManagedObjectContext:mainContext];
            EntityB* entB = [[EntityB alloc] initWithEntity:entBDesc insertIntoManagedObjectContext:mainContext];
            entB.bar = @"bbb";
            
            NSError* error = nil;
            [mainContext save:&error];
            NSLog(@"4 save:%@ %@", mainContext, error);
            
            NSManagedObjectContext* parentContext = mainContext.parentContext;
            [parentContext performBlockAndWait:^{
                NSError* error = nil;
                [parentContext save:&error];
                NSLog(@"5. save:%@ %@", parentContext, error);
            }];
            
            entBBar = entB.bar;
        }
    }
    
    // fetch EntityA with predicate including EntityB's attribute
    {
        NSFetchRequest* req = [NSFetchRequest fetchRequestWithEntityName:@"EntityA"];
        req.fetchBatchSize = 20;
        req.predicate = [NSPredicate predicateWithFormat:@"foo = %@", entBBar];
        req.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"foo" ascending:NO]];
        NSError* error = nil;
        NSArray* results = [mainContext executeFetchRequest:req error:&error];
        NSLog(@"7. result:%zd", results.count);
    }
}

@end
