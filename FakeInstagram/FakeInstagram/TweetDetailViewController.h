//
//  TweetDetailViewController.h
//  FakeInstagram
//
//  Created by Line_Hu on 14-3-7.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//
#import "TweetsViewController.h"
#import <UIKit/UIKit.h>
#import "MessageEntity.h"
#import "TweetContentCell.h"
#import "UIImageView+AFNetworking.h"
#import "Common.h"
#import "CellHeightCal.h"

@interface TweetDetailViewController : TweetsViewController
{
    
}
- (id)initWithTweet: (NSArray *)tweets style:(UITableViewStyle)style;
@property (strong, nonatomic) MessageEntity *tweetEntity;
@end
