//
//  SelfPageViewController.m
//  FakeInstagram
//
//  Created by Line_Hu on 14-3-11.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import "SelfPageViewController.h"
#import "SVProgressHUD.h"
@interface SelfPageViewController ()

@end

@implementation SelfPageViewController

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
    [super viewDidLoad];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 70, 40)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:116.0/255.0 blue:185.0/255.0 alpha:1.0];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21];
    self.navigationItem.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [self.navigationItem.titleView addSubview:titleLabel];
    titleLabel.text = NSLocalizedString(@"profile_title", nil);
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    manager = [[IGManager alloc] init];
    manager.delegate = self;
    loadMoreFooter = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0, self.collectionView.contentSize.height, self.collectionView.frame.size.width, self.collectionView.bounds.size.height)];
    loadMoreFooter.backgroundColor = [UIColor clearColor];
    loadMoreFooter.delegate = self;
    refreshHeader = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -44, self.collectionView.frame.size.width, 44)];
    refreshHeader.backgroundColor = [UIColor clearColor];
    refreshHeader.delegate = self;
    [self.collectionView addSubview:refreshHeader];
    [self.collectionView addSubview:loadMoreFooter];
    //self.title = @"Profile";
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ColCell"];
    //NSString *token = [igManager token];
    [manager startOperationWithRequesType:GET_SELF_INFO];
    [manager startOperationWithRequesType:GET_SELF_FEED];
	// Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
//    for (AFHTTPRequestOperation *op in manager.operations)
//    {
//        [op cancel];
//    }
//    manager.delegate = nil;
}


- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    for (AFHTTPRequestOperation *op in manager.operations)
    {
        [op cancel];
    }
    [manager.operations removeAllObjects];
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeClear];
    [self.userTweets removeAllObjects];
    //    IGManager *igManager = [IGManager sharedInstance];
    //    igManager.delegate = self;
    //NSString *token = [manager token];
    manager.delegate = self;
    [manager startOperationWithRequesType:GET_SELF_INFO];
    [manager startOperationWithRequesType:GET_SELF_FEED];
    [self.collectionView reloadData];
}

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view
{
    [self loadMoreData];
}

- (void)loadMoreData
{
    //    IGManager *manager = [IGManager sharedInstance];
    //    manager.delegate = self;
    if (manager.nextUrl) {
        NSLog(@"loadmoreself:%@",manager.nextUrl);
        loading = YES;
        [manager startOperationWithRequesType:GET_MORE_SELF_FEED];
    }
    else
    {
        NSLog(@"end refreshing");
        //为啥[self finishedLoading]就不的行？
        [self performSelector:@selector(finishedLoading) withObject:nil afterDelay:1.0f];
    }
}

- (void)finishedLoading
{
    loading = NO;
    [loadMoreFooter egoRefreshScrollViewDataSourceDidFinishedLoading:self.collectionView];
    [refreshHeader egoRefreshScrollViewDataSourceDidFinishedLoading:self.collectionView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
