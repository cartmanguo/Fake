//
//  Users.h
//  FakeInstagram
//
//  Created by Line_Hu on 14-2-21.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Users : NSObject
{
    
}
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *website;
@property (assign) NSInteger followers;
@property (assign) NSInteger followed;
@property (assign) NSInteger tweetCount;
@property (assign) NSInteger userID;
@property (strong, nonatomic) UIImage *avatar;
@property (strong, nonatomic) NSString *avatarUrl;
@end
