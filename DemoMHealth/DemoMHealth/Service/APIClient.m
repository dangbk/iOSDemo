//
//  APIClient.m
//  DemoMHealth
//
//  Created by DangLV on 12/07/2016.
//  Copyright © 2016 DangLV. All rights reserved.
//

#import "APIClient.h"
#import "AppSetting.h"

@implementation APIClient
+ (instancetype)sharedClient {
    static APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
    });
    return _sharedClient;
}
- (void)postToURL:(NSString*)urlPath  params:(NSDictionary*)params completetion:(APIResponseSuccess)success error:(APIResponseFailure)error {
    [self POST:urlPath parameters:params progress:nil success:success failure:error];
}
@end
