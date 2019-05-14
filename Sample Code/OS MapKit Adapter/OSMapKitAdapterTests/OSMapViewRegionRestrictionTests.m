//
//  OSMapViewRegionRestrictionTests.m
//  OSMapKitAdapter
//
//  Created by Dave Hardiman on 08/01/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

@import MapKit;
@import OSMapKitAdapter;
@import MIQTestingFramework;
@import OSTransformation;
#import "OSUKRegion.h"

@interface OSMapViewRegionRestrictionTests : XCTestCase
@property (nonatomic, strong) OSMapViewRegionRestriction *restriction;
@end

@implementation OSMapViewRegionRestrictionTests

- (void)setUp {
    [super setUp];
    self.restriction = [[OSMapViewRegionRestriction alloc] init];
}

- (void)tearDown {
    self.restriction = nil;
    [super tearDown];
}

- (void)testItHasAnInitialRegion {
    MKCoordinateRegion receivedRegion = self.restriction.initialRegion;
    CLLocationCoordinate2D receivedCentre = receivedRegion.center;
    OSCoordinateRegion croppedUK = OSCoordinateRegionForGridRect(
        OSGridRectMake(0, 0, OSGridWidth - 200000, OSGridHeight - 200000));
    CLLocationCoordinate2D expectedCentre = croppedUK.center;
    expect(receivedCentre.latitude).to.equal(expectedCentre.latitude);
    expect(receivedCentre.longitude).to.equal(expectedCentre.longitude);
    expect(receivedRegion.span.latitudeDelta).to.equal(croppedUK.span.latitudeDelta);
    expect(receivedRegion.span.longitudeDelta).to.equal(croppedUK.span.longitudeDelta);
}

- (id)mockMapViewForRegion:(MKCoordinateRegion)region {
    id mockMapView = OCMClassMock(MKMapView.class);
    [(MKMapView *)[[mockMapView stub] andReturnValue:[NSValue value:&region withObjCType:@encode(MKCoordinateRegion)]] region];
    return mockMapView;
}

- (void)testItIsNotPossibleToCreateAnInfiniteLoopWhenUpdatingTheMapView {
    MKCoordinateRegion testRegion = self.restriction.initialRegion;
    testRegion.center = CLLocationCoordinate2DMake(testRegion.center.latitude - 3, testRegion.center.longitude);
    MKCoordinateRegion adjustedRegion = testRegion;
    adjustedRegion.center.latitude = OSLowerRightCorner().latitude + (testRegion.span.latitudeDelta / 2);

    id mockMapView = [self mockMapViewForRegion:testRegion];
    [self.restriction updateMapViewRegionIfRequired:mockMapView];
    OCMVerify([mockMapView setRegion:adjustedRegion animated:YES]);
    [[mockMapView reject] setRegion:adjustedRegion animated:YES];
    [self.restriction updateMapViewRegionIfRequired:mockMapView];
    [mockMapView verify];
}

- (void)testTheMapRegionBeingWithinTheUKDoesntTriggerAnUpdate {
    MKCoordinateRegion initialRegion = self.restriction.initialRegion;
    id mockMapView = [self mockMapViewForRegion:initialRegion];
    [[mockMapView reject] setRegion:initialRegion animated:YES];
    [self.restriction updateMapViewRegionIfRequired:mockMapView];
    [mockMapView verify];
}

- (void)testIfTheMapRegionIsAboveTheUKItIsMovedBack {
    MKCoordinateRegion testRegion = self.restriction.initialRegion;
    testRegion.center = CLLocationCoordinate2DMake(testRegion.center.latitude - 3, testRegion.center.longitude);
    MKCoordinateRegion adjustedRegion = testRegion;
    adjustedRegion.center.latitude = OSLowerRightCorner().latitude + (testRegion.span.latitudeDelta / 2);
    [self performMovementTestForRegion:testRegion adjustedRegion:adjustedRegion];
}

- (void)testIfTheMapRegionIsBelowTheUKItIsMovedBack {
    MKCoordinateRegion testRegion = self.restriction.initialRegion;
    testRegion.center = CLLocationCoordinate2DMake(testRegion.center.latitude + 3, testRegion.center.longitude);
    MKCoordinateRegion adjustedRegion = testRegion;
    adjustedRegion.center.latitude = OSUpperLeftCorner().latitude - (testRegion.span.latitudeDelta / 2);
    [self performMovementTestForRegion:testRegion adjustedRegion:adjustedRegion];
}

- (void)testIfTheMapRegionIsLeftOfTheUKItIsMovedBack {
    MKCoordinateRegion testRegion = self.restriction.initialRegion;
    testRegion.center = CLLocationCoordinate2DMake(testRegion.center.latitude, testRegion.center.longitude - 3);
    MKCoordinateRegion adjustedRegion = testRegion;
    adjustedRegion.center.longitude = OSUpperLeftCorner().longitude + (testRegion.span.longitudeDelta / 2);
    [self performMovementTestForRegion:testRegion adjustedRegion:adjustedRegion];
}

- (void)testIfTheMapRegionIsRightOfTheUKItIsMovedBack {
    MKCoordinateRegion testRegion = self.restriction.initialRegion;
    testRegion.center = CLLocationCoordinate2DMake(testRegion.center.latitude, testRegion.center.longitude + 3);
    MKCoordinateRegion adjustedRegion = testRegion;
    adjustedRegion.center.longitude = OSLowerRightCorner().longitude - (testRegion.span.longitudeDelta / 2);
    [self performMovementTestForRegion:testRegion adjustedRegion:adjustedRegion];
}

- (void)performMovementTestForRegion:(MKCoordinateRegion)region adjustedRegion:(MKCoordinateRegion)adjustedRegion {
    id mockMapView = [self mockMapViewForRegion:region];
    [[mockMapView expect] setRegion:adjustedRegion animated:YES];
    [self.restriction updateMapViewRegionIfRequired:mockMapView];
    [mockMapView verify];
}

@end
