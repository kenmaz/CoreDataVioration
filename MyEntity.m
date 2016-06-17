//
//  MyEntity.m
//  CoreDataViolationCrash
//
//  Created by Kentaro Matsumae on 2016/06/17.
//  Copyright © 2016年 kenmaz.net. All rights reserved.
//

#import "MyEntity.h"
#import "CoreDataStack.h"

@implementation MyEntity

// Insert code here to add functionality to your managed object subclass

+ (void)fetch {
    NSManagedObjectContext* context = [CoreDataStack mainContext];
    
    NSFetchRequest* req = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"MyEntity" inManagedObjectContext:context];
    [req setEntity:entity];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"someValue > 0"];
    [req setPredicate:predicate];
    
    [req setFetchBatchSize:20];
    
    NSMutableArray* sortDescriptors = [[NSMutableArray alloc] init];
    NSSortDescriptor* sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"someValue" ascending:NO];
    [sortDescriptors addObject:sortDesc];
    [req setSortDescriptors:sortDescriptors];
    
    [context performBlockAndWait:^{
        NSError* error = nil;
        NSArray* res = [context executeFetchRequest:req error:&error];
        NSUInteger cnt = res.count;
        NSLog(@"%zd", cnt);
    }];
    
}

@end
