//
//  OSUKRegion.h
//  OSMapKitAdapter
//
//  Created by Dave Hardiman on 08/01/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

@import MapKit;

/**
 *  Upper left hand corner of the UK map region
 */
CLLocationCoordinate2D OSUpperLeftCorner();

/**
 *  Lower right hand corner of the UK map region
 */
CLLocationCoordinate2D OSLowerRightCorner();

/**
 *  Returns an MKMapRect that can be used to describe a bounding box
 *  for the mapping area covered by OS Maps API
 */
MKMapRect OSMapRectForUK();
