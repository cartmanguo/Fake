//
//  ProfileViewController.m
//  FakeInstagram
//
//  Created by Line_Hu on 14-2-21.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    loadMoreFooter = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0, self.collectionView.contentSize.height, self.collectionView.frame.size.width, self.collectionView.bounds.size.height)];
    loadMoreFooter.backgroundColor = [UIColor clearColor];
    loadMoreFooter.delegate = self;
    refreshHeader = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -44, self.collectionView.frame.size.width, 44)];
    refreshHeader.backgroundColor = [UIColor clearColor];
    refreshHeader.delegate = self;
    [self.collectionView addSubview:refreshHeader];
    [self.collectionView addSubview:loadMoreFooter];
    self.title = @"Profile";
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ColCell"];
    IGManager *igManager = [IGManager sharedInstance];
    igManager.delegate = self;
    NSString *token = [igManager token];
    [igManager getMyInfo:token];
    [igManager getMediaFromSelf:token maxNum:15];
    // Do any additional setup after loading the view.
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
            [avatarView setImageWithURL:[NSURL URLWithString:_user.avatarUrl] placeholderImage:[UIImage imageNamed:@"photo-placeholder.png"]];
            followedLabel.text = [NSString stringWithFormat:@"%d",_user.followed];
            followersLabel.text = [NSString stringWithFormat:@"%d",_user.followers];
            tweetLabel.text = [NSString stringWithFormat:@"%d",_user.tweetCount];
        }
        view.layer.borderWidth = 1.0;
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
                return view;
    }
    return 0;
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
    [_userTweets removeAllObjects];
    IGManager *igManager = [IGManager sharedInstance];
    igManager.delegate = self;
    NSString *token = [igManager token];
    [igManager getMyInfo:token];
    [igManager getMediaFromSelf:token maxNum:15];
    [self.collectionView reloadData];
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
    IGManager *manager = [IGManager sharedInstance];
    if (manager.hasMoreData) {
        loading = YES;
        [manager getMediaFromNextUrl:manager.nextUrl];
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

- (void)displayWithUserInfo:(Users *)user
{
    _user = user;
    [self.collectionView reloadData];
}

- (void)displayWithMediaFiles:(NSMutableArray *)media
{
    _userTweets = media;
    [self.collectionView reloadData];
    [self finishedLoading];
}

@end
