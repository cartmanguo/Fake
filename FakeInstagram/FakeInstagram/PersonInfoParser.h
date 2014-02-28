//
//  PersonInfoParser.h
//  FakeInstagram
//
//  Created by Line_Hu on 14-2-25.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//
@class Users;
@protocol DisplayWithPersonInfoDelegate <NSObject>
- (void)displayWithPersonInfo:(Users *)userInfo;
@end
#import "JSONDataParser.h"
#import "InstagramKey.h"
#import "Users.h"

@interface PersonInfoParser : JSONDataParser
{
    
}
@property (strong, nonatomic) Users *user;
@property (assign, nonatomic) id<DisplayWithPersonInfoDelegate>delegate;
- (void)parsePersonInfoDictionary:(NSDictionary *)person;
@end
