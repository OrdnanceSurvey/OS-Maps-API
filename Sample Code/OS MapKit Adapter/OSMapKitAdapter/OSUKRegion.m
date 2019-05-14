//
//  OSUKRegion.m
//  OSMapKitAdapter
//
//  Created by Dave Hardiman on 08/01/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

#import "OSUKRegion.h"
@import OSTransformation;

CLLocationCoordinate2D OSUpperLeftCorner() {
    return OSCoordinateForGridPoint(OSGridPointMake(0, OSGridHeight));
}

CLLocationCoordinate2D OSLowerRightCorner() {
    return OSCoordinateForGridPoint(OSGridPointMake(OSGridWidth, 0));
}

MKMapRect OSMapRectForUK() {
    MKMapPoint upperLeft = MKMapPointForCoordinate(OSUpperLeftCorner());
    MKMapPoint lowerRight = MKMapPointForCoordinate(OSLowerRightCorner());
    return MKMapRectMake(upperLeft.x, upperLeft.y, lowerRight.x - upperLeft.x, lowerRight.y - upperLeft.y);
}
