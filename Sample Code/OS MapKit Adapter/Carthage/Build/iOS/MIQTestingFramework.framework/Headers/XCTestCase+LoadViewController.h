//
//  XCTestCase+LoadViewController.h
//  OSMaps
//
//  Created by Dave Hardiman on 05/02/2015.
//  Copyright (c) 2015 David Hardiman. All rights reserved.
//

@import XCTest;

@interface XCTestCase (LoadViewController)

/**
 *  Instantiates a view controller from the specified storyboard in the main bundle
 *
 *  @param storyboardName       The name of the storyboard to load. Uses "Main" if nil.
 *  @param storyboardIdentifier The identifier of the storyboard
 *
 *  @return An instantiated view controller with its view loaded
 */
- (id)loadViewControllerWithIdentifier:(NSString *)storyboardIdentifier inStoryboardWithName:(NSString *)storyboardName;

@end
