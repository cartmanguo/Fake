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
- (void)displayWithUserInfo:(Users *)user;
- (void)displayWithMediaFiles:(NSMutableArray *)media;
@end
#import <Foundation/Foundation.h>
#import "InstagramKey.h"
#import "Users.h"
#import "MessageEntity.h"

@interface IGManager : NSObject
{
    
}
@property (strong, nonatomic) NSDictionary *receivedInfo;
@property (assign, nonatomic) id<ParsePersonInfoDelegate>delegate;
@property (strong, nonatomic) NSMutableArray *tweetsArray;
@property (strong, nonatomic) NSString *nextUrl;
@property (assign, nonatomic) BOOL hasMoreData;
+ (IGManager *)sharedInstance;
- (NSString *)token;
- (void)getMyInfo:(NSString *)token;
- (void)getMediaFromSelf:(NSString *)token maxNum:(NSInteger)num;
- (void)getMediaFromUser:(NSInteger)userId token:(NSString *)token maxNum:(NSInteger)num;
- (void)getMediaFromNextUrl:(NSString *)nextUrl;
@end
