//
//  OSMapProduct.h
//  OSMapProducts
//
//  Created by David Haynes on 08/02/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The available spatial references
 */
typedef NS_ENUM(NSUInteger, OSSpatialReference) {
    /**
     *  EPSG 27700 British National Grid
     */
    OSSpatialReferenceBNG,
    /**
     *  EPSG 3857 Web Mercator
     */
    OSSpatialReferenceWebMercator,
};

/**
 *  The available basemap styles
 */
typedef NS_ENUM(NSUInteger, OSBaseMapStyle) {
    /**
     *  Road style
     */
    OSBaseMapStyleRoad,
    /**
     *  Outdoor style
     */
    OSBaseMapStyleOutdoor,
    /**
     *  Light style
     */
    OSBaseMapStyleLight,
    /**
     *  Night style
     */
    OSBaseMapStyleNight,
    /**
     *  Leisure map stack. Only available in BNG
     */
    OSBaseMapStyleLeisure
};

/**
 *  Constructs the name to be used for the basemap layer in an http request.
 *
 *  @param style            The map style
 *  @param spatialReference The map spatial reference
 *
 *  @return The name to be used for the layer.
 */
NSString *NSStringFromOSMapLayer(OSBaseMapStyle style, OSSpatialReference spatialReference);

/**
 *  Return the name to use for the style
 */
NSString *NSStringFromOSBaseMapStyle(OSBaseMapStyle style);

/**
 *  Get the well known id from the spatial reference.
 *
 *  @param spatialReference The spatial reference
 *
 *  @return Well known id of the supplied spatial reference, e.g. '27700' for BNG
 */
NSInteger OSWkIDFromSpatialReference(OSSpatialReference spatialReference);

/**
 *  Extracts the base map style from a layer name
 *
 *  @param layerName The name of the layer, likely generated from `NSStringFromOSMapLayer`
 *
 *  @return The extracted style or `OSBaseMapStyleRoad` if none could be determined
 */
OSBaseMapStyle OSStyleFromLayerName(NSString *layerName);

/**
 *  Extracts teh spatial lreference from a layer name
 *
 *  @param layerName The name of the layer, likely generated from `NSStringFromOSMapLayer`
 *
 *  @return The extracted spatial reference or `OSSpatialReferenceWebMercator` if none could be determined
 */
OSSpatialReference OSSpatialReferenceFromLayerName(NSString *layerName);
