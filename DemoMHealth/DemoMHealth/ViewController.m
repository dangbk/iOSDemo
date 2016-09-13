//
//  ViewController.m
//  DemoMHealth
//
//  Created by DangLV on 12/07/2016.
//  Copyright © 2016 DangLV. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSString *currentRegion;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initViewModel];
    [_viewModel requestLocation];
}

- (void)initUI {
    [self.mapView setShowsUserLocation:YES];
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    [self.mapView setShowsCompass:YES];
}
- (void)initViewModel {
    _viewModel = [[MHealthViewModel alloc]  init];
    _viewModel.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    currentRegion = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Internal Functions

- (void)addLog:(NSString*)message {
    NSLog(@"Event : %@",message);
    [self.textViewLog addLog:message];
}

-(void)makeNotification:(NSString *)content fireDate:(NSDate *)fireDate
{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (fireDate) {
        localNotif.fireDate = fireDate;
    }
    localNotif.alertBody = content;
    localNotif.soundName = @"UILocalNotificationDefaultSoundName";
    
    if (fireDate) {
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    }else {
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
    }
}
- (void)showAlert:(NSString*)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iOS Test" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - UI Actions


- (IBAction)actionSendRequestUsingWifi:(id)sender {
    if([CommonUtils connectionType] == ConnectionTypeWiFi) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *params = [_viewModel getRandomRegionDics];
        [_viewModel sendPostRequest:URL_POST_1 params:params];
    } else {
        [self showAlert:@"Please turn on wifi connection to continue"];
    }
}

- (IBAction)actionSendRequestUsingCellunarNetwork:(id)sender {
    if([CommonUtils connectionType] == ConnectionType3G) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [_viewModel sendPostRequest:URL_POST_2 params:@{@"deviceName":@"iPhone6",@"deviceOSVersion":@"9.1"}];
    } else {
        [self showAlert:@"Please turn on cellular connection to continue"];
    }
}

- (IBAction)actionMonitorRegion:(id)sender {
    [_viewModel monitorRegion:[[_viewModel demoRegions] objectAtIndex:1]];
}
#pragma mark - View Model Delegate 
-(void)updateLocation:(CLLocation *)loc {
    [self.mapView setCenterCoordinate:loc.coordinate zoomLevel:13 animated:YES];
}
- (void)didEnterRegion:(CLCircularRegion*)region {
    //Only show notification if the region change
    if(!currentRegion || ![region.identifier isEqualToString:currentRegion]) {
        currentRegion = region.identifier;
        [self makeNotification:@"Entered" fireDate:nil];
    }
}
- (void)didFailMonitorRegion:(CLRegion *)region {
    currentRegion = nil;
}
- (void)didExitRegion:(CLRegion*)region {
    currentRegion = nil;
}

- (void)updateLogEvent:(NSString*)message {
    [self addLog:message];
}
- (void)didFinishRequest:(id)response error:(NSError*)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


@end
