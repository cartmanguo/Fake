//
//  TweetItemsParser.m
//  FakeInstagram
//
//  Created by Line_Hu on 14-2-25.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import "TweetItemsParser.h"

@implementation TweetItemsParser

- (id)init
{
    self = [super init];
    if(self)
    {
        self.tweets = [NSMutableArray array];
        self.comments = [NSMutableArray array];
    }
    return self;
}

- (void)parseTweetItems:(NSDictionary *)tweetInfo type:(RequestTypes)type
{
    NSArray *allTweets = tweetInfo[DATA_KEY];
    int tweetCount = [allTweets count];
    for(int i = 0; i < tweetCount; i++)
    {
        //NSMutableArray *comments = [NSMutableArray array];
        MessageEntity *entity = [[MessageEntity alloc] init];
        NSMutableArray *cmts = [[NSMutableArray alloc] init];
        NSDictionary *singleTweetInfo = allTweets[i];
        NSDictionary *userInfo = singleTweetInfo[@"user"];
        NSString *tweetMessage = nil;
        NSString *userName = userInfo[@"username"];
        NSString *profilePicUrl = userInfo[@"profile_picture"];
        NSDictionary *tweetContentInfo = singleTweetInfo[@"caption"];
        NSInteger userId = [userInfo[@"id"] integerValue];
        if(![tweetContentInfo isKindOfClass:[NSNull class]])
        {
            tweetMessage = tweetContentInfo[@"text"];
            entity.createdTime = [tweetContentInfo[@"created_time"] integerValue];
        }
        else
        {
            entity.createdTime = [singleTweetInfo[@"created_time"] integerValue];
        }
        //NSString *tweetMessage = [singleTweetInfo objectForKey:@"text"];
        entity.userName = userName;
        entity.tweetMessage = tweetMessage;
        Users *user = [[Users alloc] init];
        user.avatarUrl = profilePicUrl;
        user.userID = userId;
        entity.user = user;
        
        NSDictionary *imageInfo = singleTweetInfo[@"images"];
        NSDictionary *thumbnailImageInfo = imageInfo[@"standard_resolution"];
        NSString *thumbnailImageUrl = thumbnailImageInfo[@"url"];
        NSDictionary *CommentsInfo = singleTweetInfo[@"comments"];
        NSArray *allComments = CommentsInfo[DATA_KEY];
        entity.numberOfComments = [allComments count];
        entity.imageUrl = thumbnailImageUrl;
        NSDictionary *likesInfo = singleTweetInfo[@"likes"];
        NSInteger likesCount = [likesInfo[@"count"] integerValue];
        entity.numberOfLikes = likesCount;
        for (int j = 0; j<[allComments count]; j++)
        {
            NSDictionary *singleCommentInfo = allComments[j];
            NSDictionary *commentUserInfo = singleCommentInfo[@"from"];
            NSString *userName = commentUserInfo[@"username"];
            NSString *profilePicUrl = commentUserInfo[@"profile_picture"];
            NSString *commentContent = singleCommentInfo[@"text"];
            NSInteger userID = [commentUserInfo[@"id"] integerValue];
            Comments *comment = [[Comments alloc] init];
            comment.userName = userName;
            comment.userID = userID;
            comment.user_picUrl = profilePicUrl;
            comment.commentContent = commentContent;
            [cmts addObject:comment];
        }
        entity.comments = cmts;
        [_tweets addObject:entity];
        //NSLog(@"comments num:%d",[entity.comments count]);
    }
    if(tweetInfo[@"pagination"])
    {
        NSDictionary *more = tweetInfo[@"pagination"];
        if(more[@"next_url"])
        {
            NSString *nextFeedUrl = more[@"next_url"];
            self.nextUrl = nextFeedUrl;
            NSLog(@"more");
        }
        else
        {
            self.nextUrl = nil;
        }
    }
}

- (void)parseTweetItems:(NSDictionary *)tweetInfo
{
    NSArray *allTweets = tweetInfo[DATA_KEY];
    int tweetCount = [allTweets count];
    for(int i = 0; i < tweetCount; i++)
    {
        MessageEntity *entity = [[MessageEntity alloc] init];
        //NSMutableArray *cmts = [[NSMutableArray alloc] init];
        NSDictionary *singleTweetInfo = allTweets[i];
        NSDictionary *userInfo = singleTweetInfo[@"user"];
        NSString *tweetMessage = nil;
        NSString *userName = userInfo[@"username"];
        NSString *profilePicUrl = userInfo[@"profile_picture"];
        NSInteger userId = [userInfo[@"id"] integerValue];
        NSDictionary *tweetContentInfo = singleTweetInfo[@"caption"];
        if(![tweetContentInfo isKindOfClass:[NSNull class]])
        {
            tweetMessage = tweetContentInfo[@"text"];
            entity.createdTime = [tweetContentInfo[@"created_time"] integerValue];
        }
        else
        {
            entity.createdTime = [singleTweetInfo[@"created_time"] integerValue];
        }
        //NSString *tweetMessage = [singleTweetInfo objectForKey:@"text"];
        entity.userName = userName;
        entity.tweetMessage = tweetMessage;
        Users *user = [[Users alloc] init];
        user.avatarUrl = profilePicUrl;
        user.userID = userId;
        entity.user = user;
        
        NSDictionary *imageInfo = singleTweetInfo[@"images"];
        NSDictionary *thumbnailImageInfo = imageInfo[@"standard_resolution"];
        NSString *thumbnailImageUrl = thumbnailImageInfo[@"url"];
        NSDictionary *CommentsInfo = singleTweetInfo[@"comments"];
        NSArray *allComments = CommentsInfo[DATA_KEY];
        entity.numberOfComments = [allComments count];
        entity.imageUrl = thumbnailImageUrl;
        NSDictionary *likesInfo = singleTweetInfo[@"likes"];
        NSInteger likesCount = [likesInfo[@"count"] integerValue];
        entity.numberOfLikes = likesCount;
        for (int j = 0; j<[allComments count]; j++)
        {
            NSDictionary *singleCommentInfo = allComments[j];
            NSDictionary *commentUserInfo = singleCommentInfo[@"from"];
            NSString *userName = commentUserInfo[@"username"];
            NSString *profilePicUrl = commentUserInfo[@"profile_picture"];
            NSString *commentContent = singleCommentInfo[@"text"];
            Comments *comment = [[Comments alloc] init];
            comment.userName = userName;
            comment.user_picUrl = profilePicUrl;
            comment.commentContent = commentContent;
        }
        [_tweets addObject:entity];
        //NSLog(@"comments num:%d",[entity.comments count]);
    }
    if(tweetInfo[@"pagination"])
    {
        NSDictionary *more = tweetInfo[@"pagination"];
        if(more[@"next_url"])
        {
            NSString *nextFeedUrl = more[@"next_url"];
            self.nextUrl = nextFeedUrl;
            NSLog(@"more");
        }
        else
        {
            
        }
    }
    //[self.delegate displayTweets:_tweets comments:_comments];
}

- (void)parseSelfFeeds:(NSDictionary *)selfFeeds
{
    NSArray *selfFeedsArray = selfFeeds[@"data"];
    for (int i = 0; i<[selfFeedsArray count]; i++)
    {
        NSDictionary *singleTweetInfo = selfFeedsArray[i];
        ///NSLog(@"media:%@",mediaInfoDic);
        NSDictionary *imageInfo = singleTweetInfo[@"images"];
        //NSLog(@"dtl:%@",dtail);
        NSDictionary *thumbnailImageInfo = imageInfo[@"thumbnail"];
        NSString *thumbnailImageUrl = thumbnailImageInfo[@"url"];
        //NSLog(@"thumbnailurl:%@",mediaUrl);
        MessageEntity *mediaItem = [[MessageEntity alloc] init];
        mediaItem.imageUrl = thumbnailImageUrl;
        [_tweets addObject:mediaItem];
    }
    if(selfFeeds[@"pagination"])
    {
        NSDictionary *more = selfFeeds[@"pagination"];
        if([[more allKeys] count] > 1)
        {
            //self.hasMoreData = YES;
            NSString *next_url = more[@"next_url"];
            [IGManager sharedInstance].nextUrl = next_url;
        }
        else
        {
            NSLog(@"no more");
            [IGManager sharedInstance].nextUrl = nil;
        }
    }
}
@end
