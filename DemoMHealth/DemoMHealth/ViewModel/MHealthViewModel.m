//
//  MHealthViewModel.m
//  DemoMHealth
//
//  Created by DangLV on 12/07/2016.
//  Copyright © 2016 DangLV. All rights reserved.
//

#import "MHealthViewModel.h"

@implementation MHealthViewModel

-(instancetype)init {
    self = [super init];
    if(self) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _lastLocationUpdatedTime = [NSDate date];
        _lastMonitorNotificationDate = [NSDate date];
        _monitoringRegions = [[NSMutableArray alloc] init];
        [self genDemoListRegion];
    }
    return self;
}

- (void)genDemoListRegion {
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Regions" ofType:@"plist"];
    NSArray *fileArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    
    _demoRegions = [NSMutableArray array];
    for(NSDictionary *regionDict in fileArray) {
        CLCircularRegion *region = [self mapDictionaryToRegion:regionDict];
        [_demoRegions addObject:region];
    }
}

- (CLCircularRegion*)mapDictionaryToRegion:(NSDictionary*)dictionary {
    NSString *title = [dictionary valueForKey:KEY_TITLE];
    
    CLLocationDegrees latitude = [[dictionary valueForKey:KEY_LATITUDE] doubleValue];
    CLLocationDegrees longitude =[[dictionary valueForKey:KEY_LONGITUDE] doubleValue];
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    CLLocationDistance regionRadius = [[dictionary valueForKey:KEY_RADIUS] doubleValue];
    return [[CLCircularRegion alloc] initWithCenter:centerCoordinate radius:regionRadius  identifier:title];
}

- (void)requestLocation {
    
    if ([CLLocationManager locationServicesEnabled]) {
        [_delegate updateLogEvent:@"Location services enabled"];
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestAlwaysAuthorization];
        }
        if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
            [_delegate updateLogEvent:@"Monitor Region enabled"];
        }
        if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
            [_delegate updateLogEvent:@"SignificantLocationChangeEnabled"];
            [self.locationManager stopUpdatingLocation];
            [self.locationManager stopMonitoringSignificantLocationChanges];
            [self.locationManager startMonitoringSignificantLocationChanges];
        } else {
            [self.locationManager stopMonitoringSignificantLocationChanges];
            [self.locationManager stopUpdatingLocation];
            [self.locationManager startUpdatingLocation];
        }
    }
}

- (void)monitorRegion:(CLCircularRegion*)region {
    if(![_monitoringRegions containsObject:region]) {
        [self.locationManager startMonitoringForRegion:region];
        [_monitoringRegions addObject:region];
        NSString *info = [NSString stringWithFormat:@"Start monitor region %@ with center : %f,%f, Radius : %.0fm",region.identifier,region.center.latitude,region.center.longitude,region.radius];
        [_delegate updateLogEvent:info];
        
        //Check if User already inside Region
        [_locationManager requestStateForRegion:region];
    } else {
        [_delegate updateLogEvent:@"This region already in monitoring"];
    }
}
- (void)stopMonitorAllRegion {
    if(_monitoringRegions.count>0) {
        for(CLRegion *geofence in _monitoringRegions) {
            [self.locationManager stopMonitoringForRegion:geofence];
        }
        [_monitoringRegions removeAllObjects];
    }
}
- (void)sendPostRequest:(NSString*)urlPath params:(NSDictionary*)params {
    [_delegate updateLogEvent:[NSString stringWithFormat:@"Request API with Params  : %@",params]];
    [[APIClient sharedClient] postToURL:urlPath params:params completetion:^(NSURLSessionDataTask *task, id responseObject) {
        [_delegate updateLogEvent:[NSString stringWithFormat:@"Request API Success : %@",responseObject]];
        [_delegate didFinishRequest:responseObject error:nil];
        [self handleResponse:responseObject];
    } error:^(NSURLSessionDataTask *task, NSError *error) {
        [_delegate updateLogEvent:[NSString stringWithFormat:@"API Error : %@",error]];
        [_delegate didFinishRequest:nil error:error];
    }];
}

- (NSDictionary*)getRandomRegionDics {
    
    CLCircularRegion *region = _demoRegions[_currentSelectedRegionIndex];
    
    if(_currentSelectedRegionIndex == (_demoRegions.count-1)){
        _currentSelectedRegionIndex = 0;
    } else
        _currentSelectedRegionIndex++;
    
    
    return  [self dictionaryFromRegion:region];
}

- (void)handleResponse:(NSDictionary*)response {
    if(response && response[KEY_DATA]){
        //Save response to local database using CoreData
        [self saveResponse:response];
        //Check if response contain Region info
        NSDictionary *data = response[KEY_DATA];
        if(data && data[KEY_RADIUS]&& data[KEY_LATITUDE]&& data[KEY_LONGITUDE]&& data[KEY_TITLE]) {
            CLCircularRegion *region = [self regionFromDictionary:data];
            [self monitorRegion:region];
        }
    } else {
        [_delegate updateLogEvent:@"Process response error"];
    }
}
-(void)saveResponse:(NSDictionary*)dictionary {
    [[DBManager shareInstance] saveResponse:dictionary complete:^(BOOL contextDidSave, NSError *error) {
        if(contextDidSave) {
            [_delegate updateLogEvent:@"Save response to local database successfully"];
            [_delegate updateLogEvent:[NSString stringWithFormat:@"Current cache size : %ld",[[DBManager shareInstance] getAllResponseFromCache].count]];
        }
        else
            [_delegate updateLogEvent:[NSString stringWithFormat:@"Save response to local database failed %@",error]];
    }];
}

#pragma mark - Location delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.firstObject;
    self.myLocation = location;
    NSString *info = [NSString stringWithFormat:@"Location updated :%f,%f",location.coordinate.latitude,location.coordinate.longitude];
    [_delegate updateLogEvent:info];
    
    [_delegate updateLocation:location];
    if ([self.lastLocationUpdatedTime timeIntervalSinceNow] < -60) {
        self.lastLocationUpdatedTime = [NSDate date];
    }
}



-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSString *info = [NSString stringWithFormat:@"Time ：%@, enter region %@",[NSDate date],region.identifier];
    [_delegate updateLogEvent:info];
    [_delegate didEnterRegion:region];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSString *info = [NSString stringWithFormat:@"Time ：%@, exit region %@",[NSDate date],region.identifier];
    [_delegate updateLogEvent:info];
    [_delegate didExitRegion:region];
}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    [_monitoringRegions removeObject:region];
    NSString *info = [NSString stringWithFormat:@"Time：%@, failed monitor region %@",[NSDate date],region.identifier];
    [_delegate updateLogEvent:info];
    [_delegate didFailMonitorRegion:region];
}
- (void)locationManager:(CLLocationManager *)manager  didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    if(state == CLRegionStateInside) {
        NSString *info = [NSString stringWithFormat:@"Time ：%@, enter region %@",[NSDate date],region.identifier];
        [_delegate updateLogEvent:info];
        [_delegate didEnterRegion:region];
    }
}

#pragma mark - Internal Functions 

- (NSDictionary*)dictionaryFromRegion:(CLCircularRegion*)region {
    return @{KEY_TITLE:region.identifier,KEY_LATITUDE:@(region.center.latitude),KEY_LONGITUDE:@(region.center.longitude),KEY_RADIUS:@(region.radius)};
}
- (CLCircularRegion*)regionFromDictionary:(NSDictionary*)dictionary {
    
    NSString *title = [dictionary valueForKey:KEY_TITLE];
    CLLocationDegrees latitude = [[dictionary valueForKey:KEY_LATITUDE] doubleValue];
    CLLocationDegrees longitude =[[dictionary valueForKey:KEY_LONGITUDE] doubleValue];
    
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    CLLocationDistance regionRadius = [[dictionary valueForKey:KEY_RADIUS] doubleValue];
    
    return [[CLCircularRegion alloc] initWithCenter:centerCoordinate radius:regionRadius  identifier:title];
}
@end
