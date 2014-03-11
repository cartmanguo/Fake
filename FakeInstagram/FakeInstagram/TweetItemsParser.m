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
    NSArray *allTweets = [tweetInfo objectForKey:DATA_KEY];
    int tweetCount = [allTweets count];
    for(int i = 0; i < tweetCount; i++)
    {
        //NSMutableArray *comments = [NSMutableArray array];
        MessageEntity *entity = [[MessageEntity alloc] init];
        NSMutableArray *cmts = [[NSMutableArray alloc] init];
        NSDictionary *singleTweetInfo = [allTweets objectAtIndex:i];
        NSDictionary *userInfo = [singleTweetInfo objectForKey:@"user"];
        NSString *tweetMessage = nil;
        NSString *userName = [userInfo objectForKey:@"username"];
        NSString *profilePicUrl = [userInfo objectForKey:@"profile_picture"];
        NSDictionary *tweetContentInfo = [singleTweetInfo objectForKey:@"caption"];
        NSInteger userId = [[userInfo objectForKey:@"id"] integerValue];
        if(![tweetContentInfo isKindOfClass:[NSNull class]])
        {
            tweetMessage = [tweetContentInfo objectForKey:@"text"];
            entity.createdTime = [[tweetContentInfo objectForKey:@"created_time"] integerValue];
        }
        else
        {
            entity.createdTime = [[singleTweetInfo objectForKey:@"created_time"] integerValue];
        }
        //NSString *tweetMessage = [singleTweetInfo objectForKey:@"text"];
        entity.userName = userName;
        entity.tweetMessage = tweetMessage;
        Users *user = [[Users alloc] init];
        user.avatarUrl = profilePicUrl;
        user.userID = userId;
        entity.user = user;
        
        NSDictionary *imageInfo = [singleTweetInfo objectForKey:@"images"];
        NSDictionary *thumbnailImageInfo = [imageInfo objectForKey:@"standard_resolution"];
        NSString *thumbnailImageUrl = [thumbnailImageInfo objectForKey:@"url"];
        NSDictionary *CommentsInfo = [singleTweetInfo objectForKey:@"comments"];
        NSArray *allComments = [CommentsInfo objectForKey:DATA_KEY];
        entity.numberOfComments = [allComments count];
        entity.imageUrl = thumbnailImageUrl;
        NSDictionary *likesInfo = [singleTweetInfo objectForKey:@"likes"];
        NSInteger likesCount = [[likesInfo objectForKey:@"count"] integerValue];
        entity.numberOfLikes = likesCount;
        for (int j = 0; j<[allComments count]; j++)
        {
            NSDictionary *singleCommentInfo = [allComments objectAtIndex:j];
            NSDictionary *commentUserInfo = [singleCommentInfo objectForKey:@"from"];
            NSString *userName = [commentUserInfo objectForKey:@"username"];
            NSString *profilePicUrl = [commentUserInfo objectForKey:@"profile_picture"];
            NSString *commentContent = [singleCommentInfo objectForKey:@"text"];
            NSInteger userID = [[commentUserInfo objectForKey:@"id"] integerValue];
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
    if([tweetInfo objectForKey:@"pagination"])
    {
        NSDictionary *more = [tweetInfo objectForKey:@"pagination"];
        if([more objectForKey:@"next_url"])
        {
            NSString *nextFeedUrl = [more objectForKey:@"next_url"];
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
    NSArray *allTweets = [tweetInfo objectForKey:DATA_KEY];
    int tweetCount = [allTweets count];
    for(int i = 0; i < tweetCount; i++)
    {
        MessageEntity *entity = [[MessageEntity alloc] init];
        //NSMutableArray *cmts = [[NSMutableArray alloc] init];
        NSDictionary *singleTweetInfo = [allTweets objectAtIndex:i];
        NSDictionary *userInfo = [singleTweetInfo objectForKey:@"user"];
        NSString *tweetMessage = nil;
        NSString *userName = [userInfo objectForKey:@"username"];
        NSString *profilePicUrl = [userInfo objectForKey:@"profile_picture"];
        NSInteger userId = [[userInfo objectForKey:@"id"] integerValue];
        NSDictionary *tweetContentInfo = [singleTweetInfo objectForKey:@"caption"];
        if(![tweetContentInfo isKindOfClass:[NSNull class]])
        {
            tweetMessage = [tweetContentInfo objectForKey:@"text"];
            entity.createdTime = [[tweetContentInfo objectForKey:@"created_time"] integerValue];
        }
        else
        {
            entity.createdTime = [[singleTweetInfo objectForKey:@"created_time"] integerValue];
        }
        //NSString *tweetMessage = [singleTweetInfo objectForKey:@"text"];
        entity.userName = userName;
        entity.tweetMessage = tweetMessage;
        Users *user = [[Users alloc] init];
        user.avatarUrl = profilePicUrl;
        user.userID = userId;
        entity.user = user;
        
        NSDictionary *imageInfo = [singleTweetInfo objectForKey:@"images"];
        NSDictionary *thumbnailImageInfo = [imageInfo objectForKey:@"standard_resolution"];
        NSString *thumbnailImageUrl = [thumbnailImageInfo objectForKey:@"url"];
        NSDictionary *CommentsInfo = [singleTweetInfo objectForKey:@"comments"];
        NSArray *allComments = [CommentsInfo objectForKey:DATA_KEY];
        entity.numberOfComments = [allComments count];
        entity.imageUrl = thumbnailImageUrl;
        NSDictionary *likesInfo = [singleTweetInfo objectForKey:@"likes"];
        NSInteger likesCount = [[likesInfo objectForKey:@"count"] integerValue];
        entity.numberOfLikes = likesCount;
        for (int j = 0; j<[allComments count]; j++)
        {
            NSDictionary *singleCommentInfo = [allComments objectAtIndex:j];
            NSDictionary *commentUserInfo = [singleCommentInfo objectForKey:@"from"];
            NSString *userName = [commentUserInfo objectForKey:@"username"];
            NSString *profilePicUrl = [commentUserInfo objectForKey:@"profile_picture"];
            NSString *commentContent = [singleCommentInfo objectForKey:@"text"];
            Comments *comment = [[Comments alloc] init];
            comment.userName = userName;
            comment.user_picUrl = profilePicUrl;
            comment.commentContent = commentContent;
        }
        [_tweets addObject:entity];
        //NSLog(@"comments num:%d",[entity.comments count]);
    }
    if([tweetInfo objectForKey:@"pagination"])
    {
        NSDictionary *more = [tweetInfo objectForKey:@"pagination"];
        if([more objectForKey:@"next_url"])
        {
            NSString *nextFeedUrl = [more objectForKey:@"next_url"];
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
    NSArray *selfFeedsArray = [selfFeeds objectForKey:@"data"];
    for (int i = 0; i<[selfFeedsArray count]; i++)
    {
        NSDictionary *singleTweetInfo = [selfFeedsArray objectAtIndex:i];
        ///NSLog(@"media:%@",mediaInfoDic);
        NSDictionary *imageInfo = [singleTweetInfo objectForKey:@"images"];
        //NSLog(@"dtl:%@",dtail);
        NSDictionary *thumbnailImageInfo = [imageInfo objectForKey:@"thumbnail"];
        NSString *thumbnailImageUrl = [thumbnailImageInfo objectForKey:@"url"];
        //NSLog(@"thumbnailurl:%@",mediaUrl);
        MessageEntity *mediaItem = [[MessageEntity alloc] init];
        mediaItem.imageUrl = thumbnailImageUrl;
        [_tweets addObject:mediaItem];
    }
    if([selfFeeds objectForKey:@"pagination"])
    {
        NSDictionary *more = [selfFeeds objectForKey:@"pagination"];
        if([[more allKeys] count] > 1)
        {
            //self.hasMoreData = YES;
            NSString *next_url = [more objectForKey:@"next_url"];
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
