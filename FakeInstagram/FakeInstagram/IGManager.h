//
//  IGManager.h
//  FakeInstagram
//
//  Created by Line_Hu on 14-2-21.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

@class Users;
@class MessageEntity;
@protocol ParsePersonInfoDelegate <NSObject>
@optional
- (void)displayWithUserInfo:(Users *)user;
- (void)displayWithMediaFiles:(NSMutableArray *)media;
@end
#import <Foundation/Foundation.h>
#import "InstagramKey.h"
#import "Users.h"
#import "MessageEntity.h"
#import "PersonInfoParser.h"
#import "TweetItemsParser.h"

typedef enum RequestType
{
    GET_PERSONAL_INFO=0,
    GET_SELF_TWEETS,
    GET_MORE_SELF_TWEETS,
    GET_FEED,
    GET_MORE_FEED,
    GET_FOLLOWER,
    GET_FOLLOWED,
}RequestTypes;

@interface IGManager : NSObject
{
    
}
@property (strong, nonatomic) NSDictionary *receivedInfo;
@property (assign, nonatomic) id<ParsePersonInfoDelegate>delegate;
@property (strong, nonatomic) NSMutableArray *tweetsArray;
@property (strong, nonatomic) NSMutableArray *followedTweetsArray;
@property (strong, nonatomic) NSString *nextUrl;
@property (strong, nonatomic) NSString *feed_nextUrl;
@property (assign, nonatomic) BOOL hasMoreData;
+ (IGManager *)sharedInstance;
- (NSString *)token;
- (void)startOperationWithRequesType:(RequestTypes)type;
- (void)getMyInfo:(NSString *)token;
- (void)getMediaFromSelf:(NSString *)token maxNum:(NSInteger)num;
- (void)getMediaFromUser:(NSInteger)userId token:(NSString *)token maxNum:(NSInteger)num;
- (void)getMediaFromNextUrl:(NSString *)nextUrl;
- (void)getUsersFeed:(NSString *)token maxNum:(NSInteger)num;
@end
