//
//  MessageEntity.h
//  FakeInstagram
//
//  Created by Line_Hu on 14-2-21.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Comments.h"
#import "Users.h"
@interface MessageEntity : NSObject
{
    
}
@property (assign, nonatomic) NSUInteger createdTime;
@property (strong, nonatomic) NSString *tweetMessage;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *userName;
@property (assign, nonatomic) NSInteger numberOfComments;
@property (assign, nonatomic) NSInteger numberOfLikes;
@property (strong, nonatomic) NSMutableArray *comments;
@property (strong, nonatomic) NSMutableArray *commentUsers;
@property (strong, nonatomic) Users *user;
@end
