//
//  MainPageViewController.h
//  FakeInstagram
//
//  Created by Line_Hu on 14-2-21.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGManager.h"
#import "TweetContentCell.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"

@interface MainPageViewController : UITableViewController<ParsePersonInfoDelegate,EGORefreshTableHeaderDelegate,LoadMoreTableFooterDelegate,UIScrollViewDelegate>
{
    LoadMoreTableFooterView *loadMoreFooter;
    EGORefreshTableHeaderView *refreshHeader;
}
@property (strong, nonatomic) NSMutableArray *followedTweets;
@end
