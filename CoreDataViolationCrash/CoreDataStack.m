//
//  CoreDataStack.m
//  CoreDataViolationCrash
//
//  Created by Kentaro Matsumae on 2016/06/17.
//  Copyright © 2016年 kenmaz.net. All rights reserved.
//

#import "CoreDataStack.h"

@implementation CoreDataStack

static NSManagedObjectContext* savingContext;
static NSManagedObjectContext* mainContext;

+ (void)setup {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataViolationCrash" withExtension:@"momd"];
    NSManagedObjectModel* managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator* persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    NSURL* applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"CoreDataViolationCrash.sqlite"];
    
    NSError *error = nil;
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"setup error");
        abort();
    }
    
    savingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [savingContext performBlockAndWait:^{
        [savingContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    }];
    
    mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    mainContext.parentContext = savingContext;
}

+ (NSManagedObjectContext*)mainContext {
    @synchronized(self) {
        assert(mainContext);
        return mainContext;
    }
}

+ (NSManagedObjectContext*)privateContext {
    NSManagedObjectContext* context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.parentContext = savingContext;
    return context;
}

@end
