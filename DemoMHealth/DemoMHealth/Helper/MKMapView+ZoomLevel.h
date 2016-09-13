//
//  MKMapView+ZoomLevel.h
//  DemoMHealth
//
//  Created by DangLV on 12/07/2016.
//  Copyright © 2016 DangLV. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

- (double) getZoomLevel;
@end
