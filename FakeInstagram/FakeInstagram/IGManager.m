//
//  IGManager.m
//  FakeInstagram
//
//  Created by Line_Hu on 14-2-21.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import "IGManager.h"
static IGManager *sharedInstance = nil;
@implementation IGManager

+ (IGManager *)sharedInstance
{
    if (sharedInstance == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [[IGManager alloc] init];
        });
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        self.tweetsArray = [NSMutableArray array];
        self.followedTweetsArray = [NSMutableArray array];
        self.likedTweetsArray = [NSMutableArray array];
        self.operations = [NSMutableArray array];
    }
    return self;
}

- (NSURL *)getURLWithType:(RequestTypes)type token:(NSString *)token
{
    NSURL *requestUrl = nil;
    switch (type) {
        case 0:
            requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?access_token=%@",BASE_URL,INSTAGRAM_GET_MYUSER_INFO,token]];
            break;
        case 1:
            requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?access_token=%@&count=15",BASE_URL,INSTAGRAM_GET_MYUSER_MEDIA_RECENT,token]];
            break;
        case 2:
            requestUrl = [NSURL URLWithString:self.nextUrl];
            break;
        case 3:
            requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?access_token=%@&count=20",BASE_URL,INSTAGRAM_GET_MYUSER_FEED,token]];
            break;
        case 4:
            requestUrl = [NSURL URLWithString:self.nextUrl];
            break;
        case 5:
            break;
        case 6:
            break;
        case 7:
            requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?access_token=%@&count=20",BASE_URL,INSTAGRAM_GET_LIKED,token]];
            break;
        case 8:
            requestUrl = [NSURL URLWithString:self.nextUrl];
            break;
        default:
            break;
    }
    return requestUrl;
}

- (void)startOperationWithRequesType:(RequestTypes)type;
{
    NSURL *url = [self getURLWithType:type token:self.token];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
    AFHTTPRequestOperation *infoRequestOp = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    infoRequestOp.responseSerializer = [AFJSONResponseSerializer serializer];
    [infoRequestOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op,id object)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         self.receivedInfo = (NSDictionary *)object;
         NSLog(@"%@",object);
         if(type == GET_SELF_INFO)
         {
             PersonInfoParser *parser = [[PersonInfoParser alloc] init];
             [parser parsePersonInfoDictionary:(NSDictionary *)object];
             [self.delegate displayWithUserInfo:parser.user];
         }
         else if(type == GET_FEED || type == GET_SELF_FEED || type == GET_MORE_FEED || type == GET_MORE_SELF_FEED || type == GET_LIKED || type == GET_MORE_LIKED)
         {
             TweetItemsParser *parser = [[TweetItemsParser alloc] init];
             [parser parseTweetItems:(NSDictionary *)object type:type];
             for (MessageEntity *entity in parser.tweets)
             {
                 [self.tweetsArray addObject:entity];
                 //NSLog(@"count:%d",[_tweetsArray count]);
             }
             self.nextUrl = parser.nextUrl;
             
             //NSLog(@"cnt:%d",[_followedTweetsArray count]);
             [self.delegate displayWithMediaFiles:self.tweetsArray];
         }
     }failure:^(AFHTTPRequestOperation *op,NSError *error)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         [self.delegate handleErrorSituation:[error code]];
         NSLog(@"%@,%d",[error localizedDescription],[error code]);
     }];
    [_operations addObject:infoRequestOp];
    [infoRequestOp start];
    
}

- (void)getPersonInfoWithUserID:(NSInteger)userID
{
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%d/?access_token=%@",BASE_URL,INSTAGRAM_GET_OTHERUSER_INFO,userID,self.token]];
    NSLog(@"%@",requestUrl);
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
    AFHTTPRequestOperation *getUserInfoOp = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    getUserInfoOp.responseSerializer = [AFJSONResponseSerializer serializer];
    [getUserInfoOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op, id object)
     {
         NSLog(@"%@",object);
         PersonInfoParser *parser = [[PersonInfoParser alloc] init];
         [parser parsePersonInfoDictionary:(NSDictionary *)object];
         [self.delegate displayWithUserInfo:parser.user];
     }failure:^(AFHTTPRequestOperation *op, NSError *error)
     {
         NSLog(@"failed:%@",[error localizedDescription]);
         //[self.delegate handleErrorSituation:[error code]];
     }];
    [_operations addObject:getUserInfoOp];
    [getUserInfoOp start];
}

- (void)getPersonFeedWithUserID:(NSInteger)userID
{
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%d/media/recent?access_token=%@&count=15",BASE_URL,INSTAGRAM_GET_OTHERUSER_INFO,userID,self.token]];
    NSLog(@"%@",requestUrl);
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
    AFHTTPRequestOperation *getUserFeedOp = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    getUserFeedOp.responseSerializer = [AFJSONResponseSerializer serializer];
    [getUserFeedOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op, id object)
     {
         TweetItemsParser *parser = [[TweetItemsParser alloc] init];
         [parser parseTweetItems:(NSDictionary *)object type:0];
         for (MessageEntity *entity in parser.tweets)
         {
             [_tweetsArray addObject:entity];
         }
         self.nextUrl = parser.nextUrl;
         [self.delegate displayWithMediaFiles:_tweetsArray];
     }failure:^(AFHTTPRequestOperation *op, NSError *error)
     {
         NSLog(@"failed:%d,%@",[error code],[error localizedFailureReason]);
         [self.delegate handleErrorSituation:[error code]];
     }];
    [_operations addObject:getUserFeedOp];
    [getUserFeedOp start];
}

- (NSString *)token
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"myToken"];
}

- (void)getMyInfo:(NSString *)token
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?access_token=%@",BASE_URL,INSTAGRAM_GET_MYUSER_INFO,token]];
    NSLog(@"%@",requestUrl);
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
    AFHTTPRequestOperation *infoRequestOp = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    infoRequestOp.responseSerializer = [AFJSONResponseSerializer serializer];
    [infoRequestOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op,id object)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         self.receivedInfo = (NSDictionary *)object;
         //NSDictionary *dic = [self.receivedInfo objectForKey:@"data"];
         //NSLog(@"%@",[self.receivedInfo objectForKey:@"data"]);
         //NSLog(@"counts:%@",[dic objectForKey:@"counts"]);
         [self parseReceivedData:_receivedInfo];
     }failure:^(AFHTTPRequestOperation *op,NSError *error)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         
         NSLog(@"%@",[error localizedDescription]);
     }];
    [infoRequestOp start];
}

- (void)getMediaFromSelf:(NSString *)token maxNum:(NSInteger)num
{
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?access_token=%@&count=%d",BASE_URL,INSTAGRAM_GET_MYUSER_MEDIA_RECENT,token,num]];
    NSLog(@"%@",requestUrl);
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
    AFHTTPRequestOperation *infoRequestOp = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    infoRequestOp.responseSerializer = [AFJSONResponseSerializer serializer];
    [infoRequestOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op,id object)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         NSDictionary *dic = (NSDictionary *)object;
         NSLog(@"%@",dic);
         [self parseMediaInfo:dic];
         //NSLog(@"counts:%@",[dic objectForKey:@"counts"]);
     }failure:^(AFHTTPRequestOperation *op,NSError *error)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         
         NSLog(@"%@",[error localizedDescription]);
     }];
    [infoRequestOp start];
}

- (void)getUsersFeed:(NSString *)token maxNum:(NSInteger)num
{
    NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?access_token=%@&count=%d",BASE_URL,INSTAGRAM_GET_MYUSER_FEED,token,num]];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
    AFHTTPRequestOperation *infoRequestOp = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    infoRequestOp.responseSerializer = [AFJSONResponseSerializer serializer];
    [infoRequestOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op,id object)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         NSDictionary *dic = (NSDictionary *)object;
         NSLog(@"%@",dic);
         [self parseMediaInfo:dic];
         //NSLog(@"counts:%@",[dic objectForKey:@"counts"]);
     }failure:^(AFHTTPRequestOperation *op,NSError *error)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         
         NSLog(@"%@",[error localizedDescription]);
     }];
    [infoRequestOp start];
}

- (void)getMediaFromUser:(NSInteger)userId token:(NSString *)token maxNum:(NSInteger)num;
{
    
}

- (void)parseReceivedData:(NSDictionary *)data
{
    NSDictionary *infoDic = [self.receivedInfo objectForKey:@"data"];
    NSDictionary *countDic = [infoDic objectForKey:@"counts"];
    NSInteger followedCount = [[countDic objectForKey:@"follows"] integerValue];
    NSInteger followersCount = [[countDic objectForKey:@"followed_by"] integerValue];
    NSInteger tweetCount = [[countDic objectForKey:@"media"] integerValue];
    
    NSString *fullName = [infoDic objectForKey:@"full_name"];
    NSInteger idNum = [[infoDic objectForKey:@"id"] integerValue];
    NSString *photoUrl = [infoDic objectForKey:@"profile_picture"];
    NSString *userName = [infoDic objectForKey:@"username"];
    NSString *website = [infoDic objectForKey:@"website"];
    Users *user = [[Users alloc] init];
    user.userID = idNum;
    user.userName = userName;
    user.fullName = fullName;
    user.website = website;
    user.followed = followedCount;
    user.followers = followersCount;
    user.tweetCount = tweetCount;
    user.avatarUrl = photoUrl;
    NSLog(@"parsed:%d,%d,%d,%d,%@,%@",followedCount,followersCount,idNum,tweetCount,fullName,photoUrl);
    [self.delegate displayWithUserInfo:user];
}

- (void)parseMediaInfo:(NSDictionary *)data
{
    NSArray *infoDic = [data objectForKey:@"data"];
    for (int i = 0; i<[infoDic count]; i++)
    {
        NSDictionary *mediaInfoDic = [infoDic objectAtIndex:i];
        ///NSLog(@"media:%@",mediaInfoDic);
        NSDictionary *dtail = [mediaInfoDic objectForKey:@"images"];
        //NSLog(@"dtl:%@",dtail);
        NSDictionary *mediaDetail = [dtail objectForKey:@"thumbnail"];
        NSString *mediaUrl = [mediaDetail objectForKey:@"url"];
        //NSLog(@"thumbnailurl:%@",mediaUrl);
        MessageEntity *mediaItem = [[MessageEntity alloc] init];
        mediaItem.imageUrl = mediaUrl;
        [_tweetsArray addObject:mediaItem];
    }
    if([data objectForKey:@"pagination"])
    {
        NSDictionary *more = [data objectForKey:@"pagination"];
        if([[more allKeys] count] > 1)
        {
            self.hasMoreData = YES;
            NSString *next_url = [more objectForKey:@"next_url"];
            self.nextUrl = next_url;
        }
        else
        {
            NSLog(@"no more");
            self.hasMoreData = NO;
        }
        
    }
    [self.delegate displayWithMediaFiles:_tweetsArray];
}

- (void)getMediaFromNextUrl:(NSString *)nextUrl
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:nextUrl]];
    AFHTTPRequestOperation *infoRequestOp = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    infoRequestOp.responseSerializer = [AFJSONResponseSerializer serializer];
    [infoRequestOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op,id object)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         NSDictionary *dic = (NSDictionary *)object;
         NSLog(@"%@",dic);
         [self parseMediaInfo:dic];
         //NSLog(@"counts:%@",[dic objectForKey:@"counts"]);
     }failure:^(AFHTTPRequestOperation *op,NSError *error)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         
         NSLog(@"%@",[error localizedDescription]);
     }];
    [infoRequestOp start];
    
}

@end
