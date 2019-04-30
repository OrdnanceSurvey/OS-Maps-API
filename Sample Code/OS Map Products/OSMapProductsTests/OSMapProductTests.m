//
//  OSMapProductTests.m
//  OSMapProducts
//
//  Created by David on 08/02/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

@import XCTest;
@import Expecta;
@import OSMapProducts;

@interface OSMapProductTests : XCTestCase

@end

@implementation OSMapProductTests

- (void)testWellKnownIDIsReturnedCorrectlyForBNG {
    NSInteger wkidBNG = OSWkIDFromSpatialReference(OSSpatialReferenceBNG);
    expect(wkidBNG).to.equal(27700);
}

- (void)testWellKnownIDIsReturnedCorrectlyForWebMercator {
    NSInteger wkidBNG = OSWkIDFromSpatialReference(OSSpatialReferenceWebMercator);
    expect(wkidBNG).to.equal(3857);
}

- (void)testProductNameIsReturnedCorrectlyForRoadStyleInBNG {
    NSString *name = NSStringFromOSMapLayer(OSBaseMapStyleRoad, OSSpatialReferenceBNG);
    expect(name).to.equal(@"Road%2027700");
}

- (void)testProductNameIsReturnedCorrectlyForOutdoorStyleInBNG {
    NSString *name = NSStringFromOSMapLayer(OSBaseMapStyleOutdoor, OSSpatialReferenceBNG);
    expect(name).to.equal(@"Outdoor%2027700");
}

- (void)testProductNameIsReturnedCorrectlyForLightStyleInBNG {
    NSString *name = NSStringFromOSMapLayer(OSBaseMapStyleLight, OSSpatialReferenceBNG);
    expect(name).to.equal(@"Light%2027700");
}

- (void)testProductNameIsReturnedCorrectlyForNightStyleInBNG {
    NSString *name = NSStringFromOSMapLayer(OSBaseMapStyleNight, OSSpatialReferenceBNG);
    expect(name).to.equal(@"Night%2027700");
}

- (void)testProductNameIsReturnedCorrectlyForRoadStyleInWebMercator {
    NSString *name = NSStringFromOSMapLayer(OSBaseMapStyleRoad, OSSpatialReferenceWebMercator);
    expect(name).to.equal(@"Road%203857");
}

- (void)testProductNameIsReturnedCorrectlyForOutdoorStyleInWebMercator {
    NSString *name = NSStringFromOSMapLayer(OSBaseMapStyleOutdoor, OSSpatialReferenceWebMercator);
    expect(name).to.equal(@"Outdoor%203857");
}

- (void)testProductNameIsReturnedCorrectlyForLightStyleInWebMercator {
    NSString *name = NSStringFromOSMapLayer(OSBaseMapStyleLight, OSSpatialReferenceWebMercator);
    expect(name).to.equal(@"Light%203857");
}

- (void)testProductNameIsReturnedCorrectlyForNightStyleInWebMercator {
    NSString *name = NSStringFromOSMapLayer(OSBaseMapStyleNight, OSSpatialReferenceWebMercator);
    expect(name).to.equal(@"Night%203857");
}

- (void)testProductNameIsReturnedCorrectlyForLeisureStyleInBNG {
    NSString *name = NSStringFromOSMapLayer(OSBaseMapStyleLeisure, OSSpatialReferenceBNG);
    expect(name).to.equal(@"Leisure%2027700");
}

- (void)testExceptionIsRaisedCorrectlyForLeisureStyleInWebMercator {
    expect(^{
        NSStringFromOSMapLayer(OSBaseMapStyleLeisure, OSSpatialReferenceWebMercator);
    }).to.raise(NSInvalidArgumentException);
}

- (void)testItIsPossibleToExtractTheBaseMapLayerFromAString {
    expect(OSStyleFromLayerName(@"Road%203857")).to.equal(OSBaseMapStyleRoad);
    expect(OSStyleFromLayerName(@"Outdoor%203857")).to.equal(OSBaseMapStyleOutdoor);
    expect(OSStyleFromLayerName(@"Light%203857")).to.equal(OSBaseMapStyleLight);
    expect(OSStyleFromLayerName(@"Night%203857")).to.equal(OSBaseMapStyleNight);
    expect(OSStyleFromLayerName(@"Leisure%203857")).to.equal(OSBaseMapStyleLeisure);
    expect(OSStyleFromLayerName(@"random")).to.equal(OSBaseMapStyleRoad);
}

- (void)testItIsPossibleToExtractTheSpatialReferenceFromAString {
    expect(OSSpatialReferenceFromLayerName(@"Road%203857")).to.equal(OSSpatialReferenceWebMercator);
    expect(OSSpatialReferenceFromLayerName(@"Road%2027700")).to.equal(OSSpatialReferenceBNG);
    expect(OSSpatialReferenceFromLayerName(@"random")).to.equal(OSSpatialReferenceWebMercator);
}

@end
