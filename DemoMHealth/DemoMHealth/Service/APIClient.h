//
//  APIClient.h
//  DemoMHealth
//
//  Created by DangLV on 12/07/2016.
//  Copyright © 2016 DangLV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

typedef void(^APIResponseSuccess)(NSURLSessionDataTask *task, id responseObject);
typedef void(^APIResponseFailure)(NSURLSessionDataTask *task, NSError *error);

@interface APIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;
- (void)postToURL:(NSString*)urlPath  params:(NSDictionary*)params completetion:(APIResponseSuccess)success error:(APIResponseFailure)error;

@end
