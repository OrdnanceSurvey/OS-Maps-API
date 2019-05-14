//
//  OSTIleOverlayTests.m
//  OSMapKitAdapter
//
//  Created by Dave Hardiman on 06/01/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

@import MIQTestingFramework;
@import OSMapKitAdapter;
@import MapKit;

@interface OSTIleOverlayTests : XCTestCase

@end

@implementation OSTIleOverlayTests

- (void)testATileOverlayHasAURLTemplate {
    OSTileOverlay *tileOverlay = [[OSTileOverlay alloc] initWithAPIKey:@"test-key" product:OSMapProductRoad];
    expect(tileOverlay.URLTemplate).to.equal(@"https://api2.ordnancesurvey.co.uk/mapping_api/v1/service/zxy/EPSG%3A3857/Road%203857/{z}/{x}/{y}.png?key=test-key");
}

- (void)testTheOverlayIntendsToReplaceContent {
    OSTileOverlay *tileOverlay = [[OSTileOverlay alloc] initWithAPIKey:@"test-key" product:OSMapProductRoad];
    expect(tileOverlay.canReplaceMapContent).to.beTruthy();
}

- (void)testWhenSetToNotClipTheBoundingMapRectIsNull {
    OSTileOverlay *tileOverlay = [[OSTileOverlay alloc] initWithAPIKey:@"test-key" product:OSMapProductRoad];
    MKMapRect receivedRect = tileOverlay.boundingMapRect;
    expect(MKMapRectEqualToRect(receivedRect, MKMapRectWorld)).to.beTruthy();
}

- (void)testWhenSetToClipTheBoundingMapRectIsSetCorrectly {
    OSTileOverlay *tileOverlay = [[OSTileOverlay alloc] initWithAPIKey:@"test-key" product:OSMapProductRoad];
    tileOverlay.clipOverlay = YES;
    MKMapRect receivedRect = tileOverlay.boundingMapRect;
    expect(MKMapRectEqualToRect(receivedRect, OSMapRectForUK())).to.beTruthy();
}

@end
