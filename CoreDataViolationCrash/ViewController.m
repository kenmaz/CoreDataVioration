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

@implementation ViewController

- (IBAction)buttonDidTap:(id)sender {

    // insert EntityA (asyn on previate context)
    
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

    //fetch EntityB (asyn on main context)
    
    [mainContext performBlock:^{
        NSFetchRequest* req = [NSFetchRequest fetchRequestWithEntityName:@"EntityB"];
        NSError* error = nil;
        NSArray* results = [mainContext executeFetchRequest:req error:&error];
        NSLog(@"3. result:%zd", results.count);
    }];
    
    //fetch EntityA (asyn on main context)
    
    [mainContext performBlock:^{
        NSFetchRequest* req = [NSFetchRequest fetchRequestWithEntityName:@"EntityA"];
        req.fetchBatchSize = 20; // If comment out this line, No break
        req.predicate = [NSPredicate predicateWithFormat:@"foo = %@", @"wwww"]; // If comment out this line, No break
        NSError* error = nil;
        NSArray* results = [mainContext executeFetchRequest:req error:&error];  // ******* BREAK with __Multithreading_Violation_AllThatIsLeftToUsIsHonor__ !!!!! ********
        NSLog(@"7. result:%zd", results.count);
    }];
}

@end
