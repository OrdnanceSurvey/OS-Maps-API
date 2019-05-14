//
//  OSTileOverlay.h
//  OSMapKitAdapter
//
//  Created by Dave Hardiman on 06/01/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

@import MapKit;
#import "OSMapProduct.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Tile overlay subclass to use to connect to OS Maps API
 */
@interface OSTileOverlay : MKTileOverlay

/**
 *  When set to YES, the overlay will only display its content within
 *  the bounds of the area provided by the OS Maps API. Outside of that
 *  area you will still see the original mapping. When set to NO, the
 *  OS Maps will display, and all other areas will be blank. It is then
 *  up to the user to limit the map's movement to that area.
 */
@property (nonatomic, assign) BOOL clipOverlay;

/**
 *  Designated initialiser
 *
 *  @param apiKey  The OS Maps API key to use
 *  @param product The map product you wish to use
 *
 *  @return An initialised OSTileOverlay
 */
- (instancetype)initWithAPIKey:(NSString *)apiKey product:(OSMapProduct)product NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithURLTemplate:(nullable NSString *)URLTemplate NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
