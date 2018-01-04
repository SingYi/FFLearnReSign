//
//  FFProvisioninProfile.h
//  FFResign
//
//  Created by 燚 on 2018/1/4.
//  Copyright © 2018年 Interesting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFProvisioningProfile : NSObject

- (id)initWithPath:(NSString *)path;

@property (nonatomic, strong, readonly) NSString    *name;
@property (nonatomic, strong, readonly) NSString    *teamName;
@property (nonatomic, strong, readonly) NSString    *valid;
@property (nonatomic, assign, readonly) NSString    *debug;
@property (nonatomic, strong, readonly) NSDate      *creationDate;
@property (nonatomic, strong, readonly) NSDate      *expirationDate;
@property (nonatomic, strong, readonly) NSString    *UUID;
@property (nonatomic, strong, readonly) NSArray     *devices;
@property (nonatomic, assign, readonly) NSInteger   timeToLive;
@property (nonatomic, strong, readonly) NSString    *applicationIdentifier;
@property (nonatomic, strong, readonly) NSString    *bundleIdentifier;
@property (nonatomic, strong, readonly) NSArray     *certificates;
@property (nonatomic, assign, readonly) NSInteger   version;
@property (nonatomic, assign, readonly) NSArray     *prefixes;
@property (nonatomic, strong, readonly) NSString    *appIdName;
@property (nonatomic, strong, readonly) NSString    *teamIdentifier;
@property (nonatomic, strong, readonly) NSString    *path;


@end
