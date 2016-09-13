//
//  MHealthViewModel.h
//  DemoMHealth
//
//  Created by DangLV on 12/07/2016.
//  Copyright © 2016 DangLV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MHealthResponse.h"

#define CORE_DATA_CONTEXT (((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext)

@protocol MHealthViewModelDelegate <NSObject>

@optional
- (void)updateLocation:(CLLocation*)loc;
- (void)didEnterRegion:(CLRegion*)region;
- (void)didFailMonitorRegion:(CLRegion*)region;
- (void)didExitRegion:(CLRegion*)region;
- (void)updateLogEvent:(NSString*)message;
- (void)didFinishRequest:(id)response error:(NSError*)error;

@end


@interface MHealthViewModel : NSObject<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *myLocation;
@property (strong, nonatomic) NSDate *lastLocationUpdatedTime;
@property (strong, nonatomic) NSDate *lastMonitorNotificationDate;
@property (strong, nonatomic) NSMutableArray *monitoringRegions;
@property (strong, nonatomic) NSMutableArray *demoRegions;
@property (weak, nonatomic) id<MHealthViewModelDelegate> delegate;
//Demo dictionary for request params
@property (strong,nonatomic) NSDictionary *paramsJson1;
@property (assign,nonatomic) int  currentSelectedRegionIndex;

- (void)requestLocation;
- (void)monitorRegion:(CLCircularRegion*)region;
- (void)stopMonitorAllRegion;
- (void)sendPostRequest:(NSString*)urlPath params:(NSDictionary*)params;
// Get random Regions in demo list and convert to Dictionary to send
- (NSDictionary*)getRandomRegionDics;
@end