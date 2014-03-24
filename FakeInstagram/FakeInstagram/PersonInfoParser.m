//
//  PersonInfoParser.m
//  FakeInstagram
//
//  Created by Line_Hu on 14-2-25.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import "PersonInfoParser.h"

@implementation PersonInfoParser

- (void)parsePersonInfoDictionary:(NSDictionary *)person
{
    NSDictionary *personInfo = person[DATA_KEY];
    NSDictionary *countDic = personInfo[PERSON_INFO_KEY_COUNT];
    NSInteger followedCount = [countDic[PERSON_INFO_KEY_FOLLOWING] integerValue];
    NSInteger followersCount = [countDic[PERSON_INFO_KEY_FOLLOWER] integerValue];
    NSInteger tweetCount = [countDic[PERSON_INFO_KEY_TWEETCOUNT] integerValue];
    
    NSString *fullName = personInfo[PERSON_INFO_KEY_FULL_NAME];
    NSInteger idNum = [personInfo[PERSON_INFO_KEY_ID] integerValue];
    NSString *photoUrl = personInfo[PERSON_INFO_KEY_PHOTOURL];
    NSString *userName = personInfo[PERSON_INFO_KEY_NAME];
    NSString *website = personInfo[PERSON_INFO_KEY_WEBSITE];
    
    Users *user = [[Users alloc] init];
    user.userID = idNum;
    user.userName = userName;
    user.fullName = fullName;
    user.website = website;
    user.followed = followedCount;
    user.followers = followersCount;
    user.tweetCount = tweetCount;
    user.avatarUrl = photoUrl;
//    if([self.delegate respondsToSelector:@selector(displayWithPersonInfo:)])
//    {
//        [self.delegate displayWithPersonInfo:user];
//    }
    self.user = user;
}
@end
