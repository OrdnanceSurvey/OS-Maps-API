//
//  SPTCoreDataSpec.h
//  MIQTestingFramework
//
//  Created by Dave Hardiman on 03/03/2015.
//  Copyright (c) 2015 David Hardiman. All rights reserved.
//

#import <Specta/Specta.h>
@import CoreData;

#define CoreDataSpecBegin(name) _SPTCDSpecBegin(name, __FILE__, __LINE__)
#define CoreDataSpecEnd _SPTCDSpecEnd

/**
 *  A specta subclass that has a core data stack
 */
@interface SPTCoreDataSpec : SPTSpec

/**
 Context to use
 */
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

/**
 An array of instances of NSBundle to search. If nil,
 then the main bundle is searched. The model will be created
 by merging all the models found in given bundles.
 To override, you must set it before the call to setupCoreData.
 */
@property (nonatomic, strong) NSArray *modelBundles;

@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSManagedObjectModel *model;

/**
 Persistent store
 */
@property (nonatomic, strong) NSPersistentStore *store;

@end

#define _SPTCDSpecBegin(name, file, line)                                   \
    @interface name                                                         \
    ##Spec : SPTCoreDataSpec @end @implementation name##Spec - (void)spec { \
        [[self class] spt_setCurrentTestSuiteFileName:(@(file))lineNumber:(line)];

#define _SPTCDSpecEnd                      \
    self.managedObjectContext = nil;       \
    self.persistentStoreCoordinator = nil; \
    self.model = nil;                      \
    self.store = nil;                      \
    self.modelBundles = nil;               \
    }                                      \
    @end