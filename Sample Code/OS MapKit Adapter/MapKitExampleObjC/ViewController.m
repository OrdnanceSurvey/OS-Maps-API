//
//  ViewController.m
//  MapKitExampleObjC
//
//  Created by Dave Hardiman on 06/01/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

#import "ViewController.h"
@import MapKit;
@import OSMapKitAdapter;
@import OSGridPointConversion;

@interface ViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) OSMapViewRegionRestriction *restriction;
@end

@implementation ViewController

- (NSString *)apiKey {
    return [NSString stringWithContentsOfURL:[NSBundle.mainBundle URLForResource:@"APIKEY" withExtension:nil]
                                    encoding:NSUTF8StringEncoding
                                       error:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    OSTileOverlay *tileOverlay = [[OSTileOverlay alloc] initWithAPIKey:self.apiKey
                                                               product:OSMapProductOutdoor];

    tileOverlay.clipOverlay = NO; // YES allows the overlay to render alongside other maps,
    // NO replaces all MapKit content

    [self.mapView addOverlay:tileOverlay];
    self.mapView.delegate = self;

    self.restriction = [[OSMapViewRegionRestriction alloc] init];
    self.mapView.region = self.restriction.initialRegion;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:MKTileOverlay.class]) {
        return [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
    } else {
        return [[MKOverlayRenderer alloc] initWithOverlay:overlay];
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self.restriction updateMapViewRegionIfRequired:mapView];
}

@end
