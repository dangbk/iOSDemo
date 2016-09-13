//
//  CommonUtils.h
//  DemoMHealth
//
//  Created by DangLV on 13/07/2016.
//  Copyright © 2016 DangLV. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ConnectionTypeUnknown,
    ConnectionTypeNone,
    ConnectionType3G,
    ConnectionTypeWiFi
} ConnectionType;


@interface CommonUtils : NSObject
+ (ConnectionType)connectionType;
@end
