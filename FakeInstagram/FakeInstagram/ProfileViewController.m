//
//  ProfileViewController.m
//  FakeInstagram
//
//  Created by Line_Hu on 14-2-21.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import "ProfileViewController.h"
#import "SVProgressHUD.h"
#import "Common.h"
#import "TweetDetailViewController.h"

@interface ProfileViewController ()
@property (strong, nonatomic) NSString *moreFeedUrl;
@end

@implementation ProfileViewController

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
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_userTweets count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idf = @"ColCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idf forIndexPath:indexPath];
    if(_user == nil)
    {
        UIImageView *cellImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-placeholder.png"]];
        cell.backgroundView = cellImage;
    }
    else
    {
        UIImageView *cellImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-placeholder.png"]];
        MessageEntity *mediaItem = [_userTweets objectAtIndex:indexPath.row];
        [cellImage setImageWithURL:[NSURL URLWithString:mediaItem.imageUrl] placeholderImage:[UIImage imageNamed:@"photo-placeholder.png"]];
        cell.backgroundView = cellImage;
    }
    loadMoreFooter.frame = CGRectMake(0, self.collectionView.contentSize.height, self.collectionView.frame.size.width, self.collectionView.bounds.size.height);
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if(kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
        UIImageView *avatarView = (UIImageView *)[view viewWithTag:90];
        avatarView.layer.cornerRadius = avatarView.frame.size.height/2;
        UILabel *followedLabel = (UILabel *)[view viewWithTag:91];
        UILabel *followersLabel = (UILabel *)[view viewWithTag:92];
        UILabel *tweetLabel = (UILabel *)[view viewWithTag:93];
        if(_user)
        {
            //NSLog(@"followed:%d",_user.followed);
            NSString *followerLabelNumber = [Common getProperNumberForBigNumber:_user.followers];
            NSString *followedLabelNumber = [Common getProperNumberForBigNumber:_user.followed];
            NSString *tweetCountLabelNumber = [Common getProperNumberForBigNumber:_user.tweetCount];
            [avatarView setImageWithURL:[NSURL URLWithString:_user.avatarUrl] placeholderImage:[UIImage imageNamed:@"photo-placeholder.png"]];
            followedLabel.text = followedLabelNumber;
            followersLabel.text = followerLabelNumber;
            tweetLabel.text = tweetCountLabelNumber;
        }
        view.layer.borderWidth = 1.0;
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        return view;
    }
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MessageEntity *entity = [_userTweets objectAtIndex:indexPath.row];
    TweetDetailViewController *tweetDetailVC = [[TweetDetailViewController alloc] initWithTweet:[NSArray arrayWithObject:entity] style:UITableViewStylePlain];
    [self.navigationController pushViewController:tweetDetailVC animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(105, 105);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[loadMoreFooter egoRefreshScrollViewDidScroll:scrollView];
    [refreshHeader egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[loadMoreFooter egoRefreshScrollViewDidEndDragging:scrollView];
	[refreshHeader egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    
}

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view
{
    [self loadMoreData];
}

- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView *)view
{
    return loading;
}

- (void)loadMoreData
{
    //    IGManager *manager = [IGManager sharedInstance];
    //    manager.delegate = self;
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

- (void)displayWithUserInfo:(Users *)user
{
    _user = user;
    [self.collectionView reloadData];
}

- (void)handleErrorSituation:(ErrorType)errorType
{
    if(errorType == ERROR_TYPE_NOT_AUTHORIZED)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未授权" message:@"该用户设置为隐私账户" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(errorType == ERROR_TYPE_TIME_OUT)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"超时" message:@"获取信息超时，请检查网络后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    [SVProgressHUD dismiss];
}

- (void)displayWithMediaFiles:(NSMutableArray *)media
{
    [SVProgressHUD dismiss];
    _userTweets = media;
    [self.collectionView reloadData];
    [self finishedLoading];
    
    //self.moreFeedUrl = [IGManager sharedInstance].feed_nextUrl;
}

@end
