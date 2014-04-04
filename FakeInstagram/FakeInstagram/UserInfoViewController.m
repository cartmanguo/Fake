//
//  UserInfoViewController.m
//  FakeInstagram
//
//  Created by Line_Hu on 14-3-11.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import "UserInfoViewController.h"
#import "SVProgressHUD.h"
@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (id)initWithUserID:(NSInteger)userID layoutStyle:(UICollectionViewFlowLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self)
    {
        self.userID = userID;
    }
    return self;
}

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
    //
    [super viewDidLoad];
    self.titleLabel.text = self.user.userName;
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeClear];
    manager = [[IGManager alloc] init];
    manager.delegate = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
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

    [manager getPersonInfoWithUserID:_userID];
    [manager getPersonFeedWithUserID:_userID];
	// Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    for (AFHTTPRequestOperation *op in manager.operations)
    {
        [op cancel];
    }
    manager.delegate = nil;
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    for (AFHTTPRequestOperation *op in manager.operations)
    {
        [op cancel];
    }
    [manager.operations removeAllObjects];
    [self.userTweets removeAllObjects];
    //    IGManager *igManager = [IGManager sharedInstance];
    //    igManager.delegate = self;
    //NSString *token = [manager token];
    manager.delegate = self;
    [manager getPersonFeedWithUserID:_userID];
    [manager getPersonInfoWithUserID:_userID];
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
        NSLog(@"loadmore:%@",manager.nextUrl);
        loading = YES;
        [manager startOperationWithRequesType:GET_MORE_FEED];
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
