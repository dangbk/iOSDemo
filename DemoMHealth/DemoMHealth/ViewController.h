//
//  ViewController.h
//  DemoMHealth
//
//  Created by DangLV on 12/07/2016.
//  Copyright © 2016 DangLV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "MHealthViewModel.h"
#import "MKMapView+ZoomLevel.h"
#import "LoggerTextView.h"

@interface ViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,MHealthViewModelDelegate>

@property (strong,nonatomic) MHealthViewModel  *viewModel;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet LoggerTextView *textViewLog;

- (IBAction)actionSendRequestUsingWifi:(id)sender;
- (IBAction)actionSendRequestUsingCellunarNetwork:(id)sender;
- (IBAction)actionMonitorRegion:(id)sender;


@end

