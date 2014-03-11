//
//  TweetItemsParser.h
//  FakeInstagram
//
//  Created by Line_Hu on 14-2-25.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//
@protocol DisplayWithTweetsDelegate <NSObject>
- (void)displayTweets:(NSMutableArray *)tweets comments:(NSMutableArray *)comments;
@end
#import "JSONDataParser.h"
#import "MessageEntity.h"
#import "InstagramKey.h"
#import "IGManager.h"

@interface TweetItemsParser : JSONDataParser
{
    
}
@property (strong, nonatomic) NSString *nextUrl;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) NSMutableArray *comments;
@property (assign, nonatomic) id<DisplayWithTweetsDelegate>delegate;
- (void)parseTweetItems:(NSDictionary *)tweetInfo;
- (void)parseSelfFeeds:(NSDictionary *)selfFeeds;
- (void)parseTweetItems:(NSDictionary *)tweetInfo type:(RequestTypes)type;
@end
