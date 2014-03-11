//
//  _NSObject_InstagramKey.h
//  InstagramClient2.0
//
//  Created by iObitLXF on 12/3/12.
//  Copyright (c) 2012 Crino. All rights reserved.
//

/*
 权限：
 1、基本：读取用户的所有数据（关注/被关注人，照片等）（默认权限）
 2、评论：创建和删除用户的评论
 3、关系：关注或取消关注用户
 4、喜欢：赞或者取消赞用户的项
 
 */

//http://instagram.com/developer/endpoints/

#define DATA_KEY @"data"
#define PERSON_INFO_KEY_COUNT @"counts"
#define PERSON_INFO_KEY_FOLLOWER @"followed_by"
#define PERSON_INFO_KEY_FOLLOWING @"follows"
#define PERSON_INFO_KEY_TWEETCOUNT @"media"
#define PERSON_INFO_KEY_NAME @"username"
#define PERSON_INFO_KEY_FULL_NAME @"full_name"
#define PERSON_INFO_KEY_ID @"id"
#define PERSON_INFO_KEY_PHOTOURL @"profile_picture"
#define PERSON_INFO_KEY_WEBSITE @"website"

#define INSTAGRAM_APP_ID @"30afd0af659e4d73874176c22ff18328"
#define INSTAGRAMSESSIONURL @"INSTAGRAMSESSIONURL"
#define BASE_URL @"https://api.instagram.com/v1"

/*  USERS 【GET】 */


//后面加参数?access_token= xxx
#define INSTAGRAM_GET_MYUSER_INFO @"/users/self"//获取【授权】用户的信息（self 换做 user-id 则获取某人的）
#define INSTAGRAM_GET_OTHERUSER_INFO @"/users/"//获取某用户的信息

#define INSTAGRAM_GET_MYUSER_FEED @"/users/self/feed"//获取【授权】用户的feed

#define INSTAGRAM_GET_MYUSER_MEDIA_RECENT @"/users/self/media/recent"//获取【授权】用户最近发表（self 换做 user-id 则获取某人的）
#define INSTAGRAM_GET_OTHERUSER_MEDIA_RECENT @"/users/%@/media/recent"//获取某用户最近发表

#define INSTAGRAM_GET_MYUSER_MEDIA_LIKED @"/self/media/liked"//获取【授权】用户赞的media

//后面加参数?q=jack&access_token= xxx,q为用户名字
#define INSTAGRAM_GET_USER_SEARCH @"/users/search"//搜索

#define INSTAGRAM_GET_LIKED @"/users/self/media/liked"

/*  Relationship  */

#define INSTAGRAM_GET_MYUSER_FOLLOWS @"/users/self/follows"//获取【授权】用户的关注列表 （self 换做 user-id 则获取某人的）
#define INSTAGRAM_GET_OTHERUSER_FOLLOWS @"/users/%@/follows"//获取某用户的关注列表

#define INSTAGRAM_GET_MYUSER_FOLLOWED_BY @"/users/self/followed-by"//获取【授权】用户的被关注列表（self 换做 user-id 则获取某人的）
#define INSTAGRAM_GET_OTHERUSER_FOLLOWED_BY @"/users/%@/followed-by"//获取某用户的被关注列表

#define INSTAGRAM_GET_MYUSER_REGUESTED_BY @"/users/self/requested-by"//获取【授权】用户的被关注列表


#define INSTAGRAM_GET_RELATIONSHIP @"/users/%@/relationship" //获取【授权】用户与id用户的关系

#define INSTAGRAM_POST_RELATIONSHIP @"/users/%@/relationship" //重新定义【授权】用户与id用户的关系
