//
//  FFDateFormatterTools.h
//  FFResign
//
//  Created by 燚 on 2018/1/4.
//  Copyright © 2018年 Interesting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFDateFormatterTools : NSObject

@property (strong, nonatomic, readonly) NSDateFormatter *dateFormatter;

+ (instancetype)sharedFormatter;

- (NSString *)timestampForDate:(NSDate *)date;

- (NSString *)MMddHHmmssSSSForDate:(NSDate *)date;

@end
