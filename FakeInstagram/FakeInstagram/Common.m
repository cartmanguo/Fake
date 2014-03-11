//
//  Common.m
//  FakeInstagram
//
//  Created by Line_Hu on 14-3-6.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import "Common.h"

@implementation Common
+ (NSTimeInterval)timeIntervalSinceCreatedDate:(NSTimeInterval)createdTime
{
    NSDate *createdDate = [NSDate dateWithTimeIntervalSince1970:createdTime];
    return [[NSDate date] timeIntervalSinceDate:createdDate];
}

+ (NSString *)getProperNumberForBigNumber:(NSInteger)bigNumber
{
    if(bigNumber >= 0 && bigNumber <=9999)
    {
        return [NSString stringWithFormat:@"%d",bigNumber];
    }
    else if(bigNumber > 9999 && bigNumber <= 999999)
    {
        return [NSString stringWithFormat:@"%.0fk",ceil(bigNumber/1000)];
    }
    else if(bigNumber > 999999 && bigNumber <= 999999999)
    {
        return [NSString stringWithFormat:@"%.1fm",(float)bigNumber/1000000];
    }
    else if (bigNumber > 999999999)
    {
        return [NSString stringWithFormat:@"%.1fb",(float)bigNumber/1000000000];
    }
    return 0;
}
@end
