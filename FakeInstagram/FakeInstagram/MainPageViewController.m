//
//  MainPageViewController.m
//  FakeInstagram
//
//  Created by Line_Hu on 14-2-21.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import "MainPageViewController.h"
#import "PersonProfileCell.h"
#import "CellHeightCal.h"
#import "SVProgressHUD.h"
#import "Common.h"
#import <CoreText/CoreText.h>

@interface MainPageViewController ()
{
    SVProgressHUD *svHud;
}
@property (strong, nonatomic) NSString *moreFeedUrl;
@end

@implementation MainPageViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
	// Do any additional setup after loading the view.
    [super viewDidLoad];
    titleLabel.text = NSLocalizedString(@"main_title", nil);
    //self.title = @"Friends";
    self.refreshControl = [[UIRefreshControl alloc] init];
    //self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    
    manager = [[IGManager alloc] init];
    [manager startOperationWithRequesType:GET_FEED];
    manager.delegate = self;
    loadMoreFooter.delegate = self;
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"instagram_nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    //[self.tableView addSubview:refreshHeader];
}

- (void)refreshAction
{
    //[self.tableView scrollRectToVisible:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height) animated:YES];
    //防止多次获取数据，可能网络差获取比较慢，如果再点次刷新，可能就会得到两次返回的数据，so刷新时取消当前的请求
    for (AFHTTPRequestOperation *op in manager.operations)
    {
        [op cancel];
    }
    [manager.operations removeAllObjects];
    //[self.tweets removeAllObjects];
    //[self.tableView reloadData];
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeClear];
    [manager.tweetsArray removeAllObjects];
    [manager startOperationWithRequesType:GET_FEED];
}

- (void)like
{
    
}

- (void)comment
{
    
}

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view
{
    manager.delegate = self;
    NSLog(@"LoadMore:%@",manager.nextUrl);
    
    if (manager.nextUrl)
    {
        //loading = YES;
        [manager startOperationWithRequesType:GET_MORE_FEED];
    }
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    
}

- (void)finishedLoading
{
    [loadMoreFooter egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [refreshHeader egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (void)displayWithUserInfo:(Users *)user
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

