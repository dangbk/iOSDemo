//
//  LoggerTextView.m
//  DemoMHealth
//
//  Created by DangLV on 13/07/2016.
//  Copyright © 2016 DangLV. All rights reserved.
//

#import "LoggerTextView.h"

@implementation LoggerTextView
- (void)addLog:(NSString*)message {
    
    NSAssert(message != nil, @"message is nil");
    if (!self.logMsgCache) {
        self.logMsgCache = [NSMutableArray array];
    }
    [self.logMsgCache addObject:message];
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        NSString *newText = [self.text stringByAppendingString:[NSString stringWithFormat:@"\n==>%@", message]];
        self.text = newText;
        [self scrollRangeToVisible:NSMakeRange(newText.length, 0)];
    });
}
@end
