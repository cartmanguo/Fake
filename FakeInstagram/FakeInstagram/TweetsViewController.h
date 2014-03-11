//
//  TweetsViewController.h
//  FakeInstagram
//
//  Created by Line_Hu on 14-3-10.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGManager.h"
#import "TweetContentCell.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"
#import "Common.h"

//this is the base class for viewcontrollers that display tweets

@interface TweetsViewController : UITableViewController<ParsePersonInfoDelegate,EGORefreshTableHeaderDelegate,LoadMoreTableFooterDelegate,UIScrollViewDelegate>
{
    LoadMoreTableFooterView *loadMoreFooter;
    EGORefreshTableHeaderView *refreshHeader;
}
@property (strong, nonatomic) NSMutableArray *tweets;
@end
