//
//  FFDateFormatterTools.m
//  FFResign
//
//  Created by 燚 on 2018/1/4.
//  Copyright © 2018年 Interesting. All rights reserved.
//

#import "FFDateFormatterTools.h"

@implementation FFDateFormatterTools

#pragma mark - Initialization
static FFDateFormatterTools *istance;
+ (instancetype)sharedFormatter {
    @synchronized(self) {
        if(istance == nil) {
            istance = [[FFDateFormatterTools alloc] init];
            return istance;
        }
    }
    return istance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setLocale:[NSLocale currentLocale]];
    }
    return self;
}

- (void)dealloc {
    _dateFormatter = nil;
}

#pragma mark - Formatter
- (NSString *)timestampForDate:(NSDate *)date
{
    if (!date) {
        return nil;
    }

    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    return [self.dateFormatter stringFromDate:date];
}

- (NSString *)MMddHHmmssSSSForDate:(NSDate *)date {
    if (!date) {
        return nil;
    }

    self.dateFormatter.dateFormat = @"MM/dd HH:mm:ss SSS";
    return [self.dateFormatter stringFromDate:date];
}


@end
