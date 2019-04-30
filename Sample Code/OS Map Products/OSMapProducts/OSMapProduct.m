//
//  OSMapProduct.m
//  OSMapProducts
//
//  Created by David Haynes on 08/02/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

#import "OSMapProduct.h"

/**
 *  Return the name to use for the style
 */
NSString *NSStringFromOSBaseMapStyle(OSBaseMapStyle style) {
    switch (style) {
        case OSBaseMapStyleRoad:
            return @"Road";
        case OSBaseMapStyleOutdoor:
            return @"Outdoor";
        case OSBaseMapStyleLight:
            return @"Light";
        case OSBaseMapStyleNight:
            return @"Night";
        case OSBaseMapStyleLeisure:
            return @"Leisure";
    }
}

/**
 *  Return the name to use for the spatial reference
 */
NSString *NSStringFromOSSpatialReference(OSSpatialReference spatialReference) {
    switch (spatialReference) {
        case OSSpatialReferenceBNG:
            return @"27700";
        case OSSpatialReferenceWebMercator:
            return @"3857";
    }
}

/**
 *  Return the name to use for the layer in an http request
 */
NSString *NSStringFromOSMapLayer(OSBaseMapStyle style, OSSpatialReference spatialReference) {
    if (style == OSBaseMapStyleLeisure && spatialReference == OSSpatialReferenceWebMercator) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Leisure stack is only available in BNG" userInfo:nil];
    }
    NSString *styleName = NSStringFromOSBaseMapStyle(style);
    NSString *spatialReferenceName = NSStringFromOSSpatialReference(spatialReference);
    NSString *productName = [NSString stringWithFormat:@"%@ %@", styleName, spatialReferenceName];
    return [productName stringByAddingPercentEncodingWithAllowedCharacters:
                            [NSCharacterSet URLPathAllowedCharacterSet]];
}

NSInteger OSWkIDFromSpatialReference(OSSpatialReference spatialReference) {
    NSString *name = NSStringFromOSSpatialReference(spatialReference);
    return [name integerValue];
}

OSBaseMapStyle OSStyleFromLayerName(NSString *layerName) {
    NSString *first = [[layerName componentsSeparatedByString:@"%20"] firstObject];
    if ([first isEqualToString:NSStringFromOSBaseMapStyle(OSBaseMapStyleOutdoor)]) {
        return OSBaseMapStyleOutdoor;
    } else if ([first isEqualToString:NSStringFromOSBaseMapStyle(OSBaseMapStyleLight)]) {
        return OSBaseMapStyleLight;
    } else if ([first isEqualToString:NSStringFromOSBaseMapStyle(OSBaseMapStyleNight)]) {
        return OSBaseMapStyleNight;
    } else if ([first isEqualToString:NSStringFromOSBaseMapStyle(OSBaseMapStyleLeisure)]) {
        return OSBaseMapStyleLeisure;
    }
    return OSBaseMapStyleRoad;
}

OSSpatialReference OSSpatialReferenceFromLayerName(NSString *layerName) {
    NSString *last = [[layerName componentsSeparatedByString:@"%20"] lastObject];
    if ([last isEqualToString:NSStringFromOSSpatialReference(OSSpatialReferenceBNG)]) {
        return OSSpatialReferenceBNG;
    }
    return OSSpatialReferenceWebMercator;
}
