//
//  LikedViewController.m
//  FakeInstagram
//
//  Created by Line_Hu on 14-3-10.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import "LikedViewController.h"
#import "SVProgressHUD.h"

@interface LikedViewController ()

@end

@implementation LikedViewController

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
    self.title = @"Liked";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.refreshControl = [[UIRefreshControl alloc] init];
    //self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[TweetContentCell class] forCellReuseIdentifier:@"MessageCell"];
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeClear];
    manager = [[IGManager alloc] init];
    manager.delegate = self;
    [manager startOperationWithRequesType:GET_LIKED];
    loadMoreFooter = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0, self.tableView.contentSize.height, self.tableView.frame.size.width, self.tableView.bounds.size.height)];
    loadMoreFooter.backgroundColor = [UIColor clearColor];
    loadMoreFooter.delegate = self;
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.2 green:0.3 blue:0.6 alpha:1.0];
    [self.tableView addSubview:loadMoreFooter];
    //[self.tableView addSubview:refreshHeader];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
//    for (AFHTTPRequestOperation *op in manager.operations)
//    {
//        [op cancel];
//    }
}

- (void)refreshAction
{
    for (AFHTTPRequestOperation *op in manager.operations)
    {
        [op cancel];
    }
    
    [manager.operations removeAllObjects];
    [self.tweets removeAllObjects];
    [self.tableView reloadData];
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeClear];
    [manager startOperationWithRequesType:GET_LIKED];
}

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view
{
    NSLog(@"LoadMore:%@",manager.nextUrl);
    
    if (manager.nextUrl)
    {
        //loading = YES;
        [manager startOperationWithRequesType:GET_MORE_LIKED];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
