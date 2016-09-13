//
//  LoggerTextView.h
//  DemoMHealth
//
//  Created by DangLV on 13/07/2016.
//  Copyright © 2016 DangLV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoggerTextView : UITextView
@property (nonatomic, strong) NSMutableArray *logMsgCache;
- (void)addLog:(NSString*)message;
@end
