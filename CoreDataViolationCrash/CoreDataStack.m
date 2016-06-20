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
    
    NSMutableDictionary *sqliteOptions = [NSMutableDictionary dictionary];
    [sqliteOptions setObject:@"WAL" forKey:@"journal_mode"];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             sqliteOptions, NSSQLitePragmasOption,
                             nil];
    
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    savingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [savingContext performBlockAndWait:^{
        [savingContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    }];
    
    mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [mainContext setParentContext:savingContext];
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
