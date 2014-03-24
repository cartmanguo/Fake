//
//  IGManager.h
//  FakeInstagram
//
//  Created by Line_Hu on 14-2-21.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

typedef NS_ENUM(NSInteger, RequestTypes)
{
    GET_SELF_INFO=0,
    GET_SELF_FEED,
    GET_MORE_SELF_FEED,
    GET_FEED,
    GET_MORE_FEED,
    GET_FOLLOWER,
    GET_FOLLOWED,
    GET_LIKED,
    GET_MORE_LIKED,
    GET_USER_INFO,
};

typedef NS_ENUM(NSInteger, ErrorType)
{
    ERROR_TYPE_TIME_OUT=-1001,
    ERROR_TYPE_NOT_AUTHORIZED=-1011,
};

@class Users;
@class MessageEntity;
@protocol ParsePersonInfoDelegate <NSObject>
@optional
- (void)displayWithUserInfo:(Users *)user;
- (void)displayWithMediaFiles:(NSMutableArray *)media;
- (void)handleErrorSituation:(ErrorType)errorType;
@end
#import <Foundation/Foundation.h>
#import "InstagramKey.h"
#import "Users.h"
#import "MessageEntity.h"
#import "PersonInfoParser.h"
#import "TweetItemsParser.h"



@interface IGManager : NSObject
{
    
}
@property (strong, nonatomic) NSMutableArray *operations;
@property (strong, nonatomic) NSDictionary *receivedInfo;
@property (assign, nonatomic) id<ParsePersonInfoDelegate>delegate;
@property (strong, nonatomic) NSMutableArray *tweetsArray;
@property (strong, nonatomic) NSMutableArray *followedTweetsArray;
@property (strong, nonatomic) NSMutableArray *likedTweetsArray;
@property (strong, nonatomic) NSString *nextUrl;
@property (strong, nonatomic) NSString *feed_nextUrl;
@property (assign, nonatomic) BOOL hasMoreData;
+ (IGManager *)sharedInstance;
- (NSString *)token;
- (void)startOperationWithRequesType:(RequestTypes)type;
- (void)getPersonInfoWithUserID:(NSInteger)userID;
- (void)getPersonFeedWithUserID:(NSInteger)userID;
- (void)getMyInfo:(NSString *)token;
- (void)getMediaFromSelf:(NSString *)token maxNum:(NSInteger)num;
- (void)getMediaFromUser:(NSInteger)userId token:(NSString *)token maxNum:(NSInteger)num;
- (void)getMediaFromNextUrl:(NSString *)nextUrl;
- (void)getUsersFeed:(NSString *)token maxNum:(NSInteger)num;
@end
