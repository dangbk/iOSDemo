//
//  DBManager.m
//  DemoMHealth
//
//  Created by DangLV on 13/07/2016.
//  Copyright © 2016 DangLV. All rights reserved.
//

#import "DBManager.h"
#import "MHealthResponse.h"


@implementation DBManager
+(instancetype)shareInstance {
    static DBManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[DBManager alloc] init];
        }
    });
    return instance;
}
- (void)saveResponse:(NSDictionary*)dictionary complete:(CompletedHandler)callBack {
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        MHealthResponse *entity = [MHealthResponse MR_createEntityInContext:localContext];
        entity.requestDate = [NSDate dateWithTimeIntervalSince1970:[dictionary[KEY_REQUEST_TIME] longValue]];
        entity.requestStatus = @([dictionary[KEY_SUCCESS] boolValue]);
        entity.response = dictionary[KEY_DATA];
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (callBack) {
            callBack(contextDidSave, error);
        }
    }];
}
- (NSArray*)getAllResponseFromCache{
    NSArray *list = [MHealthResponse MR_findAll];
    return list;
}
@end
