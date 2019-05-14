//
//  MIQCoreDataTestBase.h
//
//  Created by David Hardiman on 21/01/2011.
//  Copyright 2011 Mobile IQ. All rights reserved.
//

@import XCTest;
@import CoreData;

/**
 Base class for Core Data testing
 */
@interface MIQCoreDataTestCase : XCTestCase
/**
 Context to use
 */
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 Persistent store
 */
@property (nonatomic, strong) NSPersistentStore *store;

/**
 An array of instances of NSBundle to search. If nil,
 then the main bundle is searched. The model will be created
 by merging all the models found in given bundles.
 To override, you must set it before the call to setupCoreData.
 */
@property (nonatomic, strong) NSArray *modelBundles;

- (void)setupCoreData;

@end
