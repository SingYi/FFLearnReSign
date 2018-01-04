//
//  FFFileTools.m
//  FFResign
//
//  Created by 燚 on 2018/1/4.
//  Copyright © 2018年 Interesting. All rights reserved.
//

#import "FFFileTools.h"

#import "FFProvisioningProfile.h"

static const NSString *kMobileprovisionDirName = @"Library/MobileDevice/Provisioning Profiles";

@implementation FFFileTools {
    NSFileManager *manager;
    // provisionprofile 的扩展名
    NSArray *provisionExtensions;
}

static FFFileTools *instance;

+ (instancetype)sharedTools {
    @synchronized(self) {
        if(instance == nil) {
            instance = [[FFFileTools alloc] init];
            return instance;
        }
    }
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        manager = [NSFileManager defaultManager];
        provisionExtensions = @[@"mobileprovision", @"provisionprofile"];
    }
    return self;
}

- (NSArray *)lackSupportUtility {
    NSMutableArray *result = @[].mutableCopy;

    if (![manager fileExistsAtPath:@"/usr/bin/zip"])
        [result addObject:@"/usr/bin/zip"];

    if (![manager fileExistsAtPath:@"/usr/bin/unzip"])
        [result addObject:@"/usr/bin/unzip"];

    if (![manager fileExistsAtPath:@"/usr/bin/codesign"])
        [result addObject:@"/usr/bin/codesign"];

    return result.copy;
}

#pragma mark - Get a certificate
- (void)getCertificatesSuccess:(void (^)(NSArray *))successBlock error:(void (^)(NSString *error))errorBlock {

    NSTask *certTask = [[NSTask alloc] init];
    [certTask setLaunchPath:@"/usr/bin/security"];
    [certTask setArguments:[NSArray arrayWithObjects:@"find-identity", @"-v", @"-p", @"codesigning", nil]];

    NSPipe *pipe = [NSPipe pipe];
    [certTask setStandardOutput:pipe];
    [certTask setStandardError:pipe];
    NSFileHandle *handle = [pipe fileHandleForReading];
    [certTask launch];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 检查 KeyChain 中是否有证书，然后把证书保存到 self.certificatesArray
        NSString *securityResult = [[NSString alloc] initWithData:[handle readDataToEndOfFile] encoding:NSASCIIStringEncoding];
        if (securityResult == nil || securityResult.length < 1) return;
        NSArray *rawResult = [securityResult componentsSeparatedByString:@"\""];
        NSMutableArray *tempGetCertsResult = [NSMutableArray arrayWithCapacity:20];
        for (int i = 0; i <= [rawResult count] - 2; i += 2) {
            if (!(rawResult.count - 1 < i + 1)) {
                // 有效的
                [tempGetCertsResult addObject:[rawResult objectAtIndex:i+1]];
            }
        }

        __block NSMutableArray *certificatesArray = [NSMutableArray arrayWithArray:tempGetCertsResult];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (certificatesArray.count > 0) {
                if (successBlock != nil)
                    successBlock(certificatesArray.copy);
            } else {
                if (errorBlock != nil)
                    errorBlock(@"There aren't Signign Certificates");
            }
        });
    });
}

#pragma mark - ProvisioningProfile
- (NSArray *)getProvisioningProfiles {

    NSString *homePath = NSHomeDirectory();
    NSMutableArray *homePathArray = [[homePath componentsSeparatedByString:@"/"] mutableCopy];
    [homePathArray removeObject:@""];

    NSString *path = [NSString stringWithFormat:@"/%@/%@/%@", homePathArray[0],homePathArray[1], kMobileprovisionDirName];

    NSArray *provisioningProfiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];

    provisioningProfiles = [provisioningProfiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@", provisionExtensions]];

    NSMutableArray *provisioningArray = @[].mutableCopy;
    //筛选描述文件是否为发布描述文件
    [provisioningProfiles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *path = (NSString*)obj;
        BOOL isDirectory;
        if ([manager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), kMobileprovisionDirName, path] isDirectory:&isDirectory]) {
            FFProvisioningProfile *profile = [[FFProvisioningProfile alloc] initWithPath:[NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), kMobileprovisionDirName, path]];

            [provisioningArray addObject:profile];
        }
    }];

    //按文件名排序
    provisioningArray = [[provisioningArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [((FFProvisioningProfile *)obj1).name compare:((FFProvisioningProfile *)obj2).name];
    }] mutableCopy];

    return provisioningArray.copy;
}






@end
