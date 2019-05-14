//
//  OSMapViewRegionRestriction.h
//  OSMapKitAdapter
//
//  Created by Dave Hardiman on 08/01/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

@import MapKit;

NS_ASSUME_NONNULL_BEGIN

/**
 *  `MKMapView` doesn't provide a simple API to restrict
 *  the region and zoom levels, so this is a example object
 *  that can be used to approximate that restriction.
 */
@interface OSMapViewRegionRestriction : NSObject

/**
 *  Suggested region to initially set your map to, which shows most of the
 *  UK at a zoom level where tiles are served
 */
@property (nonatomic, readonly) MKCoordinateRegion initialRegion;

/**
 *  Checks the maps region and if it has strayed outside the bounds of the uk,
 *  politely moves it back inside.
 *
 *  @param mapView The `MKMapView` to check
 */
- (void)updateMapViewRegionIfRequired:(MKMapView *)mapView;

@end

NS_ASSUME_NONNULL_END
