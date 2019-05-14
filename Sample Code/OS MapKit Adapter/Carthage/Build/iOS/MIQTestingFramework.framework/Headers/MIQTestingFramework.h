//
//  MIQTestingFramework.h
//  MIQTestingFramework
//
//  Created by Dave Hardiman on 23/07/2015.
//  Copyright (c) 2015 Mobile IQ. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for MIQTestingFramework.
FOUNDATION_EXPORT double MIQTestingFrameworkVersionNumber;

//! Project version string for MIQTestingFramework.
FOUNDATION_EXPORT const unsigned char MIQTestingFrameworkVersionString[];

@import XCTest;
#define EXP_SHORTHAND
@import Expecta;
@import Specta;
@import OCMock;
@import OHHTTPStubs;
#import <MIQTestingFramework/MIQCoreDataTestCase.h>
#import <MIQTestingFramework/SPTCoreDataSpec.h>
#import <MIQTestingFramework/XCTestCase+LoadViewController.h>
#import <MIQTestingFramework/MIQMockURLSession.h>
