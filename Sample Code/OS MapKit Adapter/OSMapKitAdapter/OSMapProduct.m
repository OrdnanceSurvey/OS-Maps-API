//
//  OSMapProduct.m
//  OSMapKitAdapter
//
//  Created by Dave Hardiman on 06/01/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

#import "OSMapProduct.h"

NSString *NSStringFromOSMapProduct(OSMapProduct product) {
    switch (product) {
        case OSMapProductRoad:
            return @"Road 3857";
        case OSMapProductOutdoor:
            return @"Outdoor 3857";
        case OSMapProductLight:
            return @"Light 3857";
        case OSMapProductNight:
            return @"Night 3857";
    }
}
