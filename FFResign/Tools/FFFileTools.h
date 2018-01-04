//
//  FFFileTools.h
//  FFResign
//
//  Created by 燚 on 2018/1/4.
//  Copyright © 2018年 Interesting. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TEMP_PATH [NSTemporaryDirectory() stringByAppendingPathComponent:@"resign"]

@interface FFFileTools : NSObject

/** 单利 */
+ (instancetype)sharedTools;

/** 获取有效的证书 */
- (void)getCertificatesSuccess:(void (^)(NSArray *array))successBlock error:(void (^)(NSString *error))errorBlock;

/** 获取配置文件 */
- (NSArray *)getProvisioningProfiles;

- (NSArray *)lackSupportUtility;

@end
