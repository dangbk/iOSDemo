//
//  DBManager.h
//  DemoMHealth
//
//  Created by DangLV on 13/07/2016.
//  Copyright © 2016 DangLV. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletedHandler)(BOOL contextDidSave,NSError * error);

@interface DBManager : NSObject
+(instancetype)shareInstance;
- (void)saveResponse:(NSDictionary*)response complete:(CompletedHandler)callBack;
- (NSArray*)getAllResponseFromCache;
@end
