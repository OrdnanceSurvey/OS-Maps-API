//
//  OSMapViewRegionRestriction.m
//  OSMapKitAdapter
//
//  Created by Dave Hardiman on 08/01/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

#import "OSMapViewRegionRestriction.h"
@import OSTransformation;
#import "OSUKRegion.h"

@interface OSMapViewRegionRestriction ()
@property (nonatomic, assign) BOOL blockUpdate;
@end

@implementation OSMapViewRegionRestriction

- (MKCoordinateRegion)mapKitRegionFromOSCoordinateRegion:(OSCoordinateRegion)input {
    NSValue *castValue = [NSValue value:&input withObjCType:@encode(OSCoordinateRegion)];
    MKCoordinateRegion output;
    [castValue getValue:&output];
    return output;
}

- (instancetype)init {
    if ((self = [super init])) {
        OSCoordinateRegion zoomedUK = OSCoordinateRegionForGridRect(
            OSGridRectMake(0, 0, OSGridWidth - 200000, OSGridHeight - 200000));
        _initialRegion = [self mapKitRegionFromOSCoordinateRegion:zoomedUK];
    }
    return self;
}

- (void)updateMapViewRegionIfRequired:(MKMapView *)mapView {
    if (self.blockUpdate) {
        self.blockUpdate = NO;
        return;
    }
    MKCoordinateRegion currentRegion = mapView.region;
    bool shouldChangeLong = YES;
    bool shouldChangeLat = YES;

    CLLocationCoordinate2D topLeftCoordinate = OSUpperLeftCorner();
    CLLocationCoordinate2D bottomRightCoordinate = OSLowerRightCorner();

    if ((currentRegion.center.longitude - (currentRegion.span.longitudeDelta / 2)) < topLeftCoordinate.longitude) {
        currentRegion.center.longitude = (topLeftCoordinate.longitude + (currentRegion.span.longitudeDelta / 2));
    } else if ((currentRegion.center.longitude + (currentRegion.span.longitudeDelta / 2)) > bottomRightCoordinate.longitude) {
        currentRegion.center.longitude = (bottomRightCoordinate.longitude - (currentRegion.span.longitudeDelta / 2));
    } else {
        shouldChangeLong = NO;
    }

    if ((currentRegion.center.latitude + (currentRegion.span.latitudeDelta / 2)) > topLeftCoordinate.latitude) {
        currentRegion.center.latitude = (topLeftCoordinate.latitude - (currentRegion.span.latitudeDelta / 2));
    } else if ((currentRegion.center.latitude - (currentRegion.span.latitudeDelta / 2)) < bottomRightCoordinate.latitude) {
        currentRegion.center.latitude = (bottomRightCoordinate.latitude + (currentRegion.span.latitudeDelta / 2));
    } else {
        shouldChangeLat = NO;
    }

    if (shouldChangeLong || shouldChangeLat) {
        self.blockUpdate = YES;
        [mapView setRegion:currentRegion animated:YES];
    }
}

@end
