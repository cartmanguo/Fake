//
//  Common.h
//  FakeInstagram
//
//  Created by Line_Hu on 14-3-6.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject
+ (NSTimeInterval)timeIntervalSinceCreatedDate:(NSTimeInterval)createdTime;
+(NSString *)getProperNumberForBigNumber:(NSInteger)bigNumber;//数字较大，需要转换成12k,22.4m
@end
