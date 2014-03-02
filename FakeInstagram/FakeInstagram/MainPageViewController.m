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

@interface MainPageViewController ()

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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Tweets!";
    IGManager *manager = [IGManager sharedInstance];
    manager.delegate = self;
    [self.tableView registerClass:[TweetContentCell class] forCellReuseIdentifier:@"MessageCell"];
    [manager startOperationWithRequesType:GET_FEED];
    loadMoreFooter = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0, self.tableView.contentSize.height, self.tableView.frame.size.width, self.tableView.bounds.size.height)];
    loadMoreFooter.backgroundColor = [UIColor clearColor];
    loadMoreFooter.delegate = self;
    refreshHeader = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -44, self.tableView.frame.size.width, 44)];
    refreshHeader.backgroundColor = [UIColor clearColor];
    refreshHeader.delegate = self;
    //[self.tableView addSubview:loadMoreFooter];
    //[self.tableView addSubview:refreshHeader];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_followedTweets count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 350.0;
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    MessageEntity *entity = [_followedTweets objectAtIndex:indexPath.section];
    return [CellHeightCal calculateCellHeightWithMessage:entity andComments:entity.comments];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idf = @"MessageCell";
    TweetContentCell *cell = [tableView dequeueReusableCellWithIdentifier:idf];

    if(_followedTweets)
    {
        MessageEntity *entity = [_followedTweets objectAtIndex:indexPath.section];
        //NSLog(@"tweet:%@",entity.tweetMessage);
        UIImageView *tweetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        [tweetImageView setImageWithURL:[NSURL URLWithString:entity.imageUrl] placeholderImage:[UIImage imageNamed:@"photo-placeholder.png"]];
        [cell addSubview:tweetImageView];
        //[cell.tweetImageView setImageWithURL:[NSURL URLWithString:entity.imageUrl] placeholderImage:[UIImage imageNamed:@"photo-placeholder.png"]];
        //Comments *comment = [entity.comments objectAtIndex:indexPath.row];
        
        //message
        if ([entity.tweetMessage length] > 0)
        {
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0+300, 320, 40)];
            [cell addSubview:messageLabel];
            messageLabel.numberOfLines = 0;
            messageLabel.font = [UIFont systemFontOfSize:12];
            messageLabel.text = entity.tweetMessage;
            //likes
            if(entity.numberOfLikes > 0)
            {
                UILabel *likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0+300+40, 320, 20)];
                likeLabel.numberOfLines = 0;
                likeLabel.font = [UIFont systemFontOfSize:12];
                likeLabel.text = [NSString stringWithFormat:@"%d 条称赞",entity.numberOfLikes];
                [cell addSubview:likeLabel];
                if([entity.comments count] == 1)
                {
                    Comments *comment = [entity.comments objectAtIndex:0];
                    UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0+300+40+20, 320, 40)];
                    commentLabel1.numberOfLines = 0;
                    commentLabel1.font = [UIFont systemFontOfSize:12];
                    commentLabel1.text = comment.commentContent;
                    [cell addSubview:commentLabel1];
                }
                else if ([entity.comments count] == 2)
                {
                    for (int i = 0; i<=1; i++)
                    {
                        Comments *comment = [entity.comments objectAtIndex:i];
                        UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0+300+40+20*(i+1), 320, 40)];
                        commentLabel1.numberOfLines = 0;
                        commentLabel1.font = [UIFont systemFontOfSize:12];
                        commentLabel1.text = comment.commentContent;
                        [cell addSubview:commentLabel1];
                    }
                }
                else if ([entity.comments count] >= 3)
                {
                    for (int i = 0; i<=2; i++)
                    {
                        Comments *comment = [entity.comments objectAtIndex:i];
                        UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0+300+40+20*(i+1), 320, 40)];
                        commentLabel1.numberOfLines = 0;
                        commentLabel1.font = [UIFont systemFontOfSize:12];
                        NSLog(@"comment:%@",comment.commentContent);
                        commentLabel1.text = comment.commentContent;
                        [cell addSubview:commentLabel1];
                    }
                }

            }
            //no likes
            else
            {
                
            }
        }
        else
        {
            if(entity.numberOfLikes > 0)
            {
                
            }
        }
        
        cell.messageLabel.text = entity.tweetMessage;
        cell.likesLabel.text = [NSString stringWithFormat:@"%d 条称赞",entity.numberOfLikes];
    }
    loadMoreFooter.frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.frame.size.width, self.tableView.bounds.size.height);
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    MessageEntity *entity = [_followedTweets objectAtIndex:section];
//    return entity.userName;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.alpha = 0.9;
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    avatar.layer.cornerRadius = 15;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5+avatar.frame.size.width+5, 0, 130, 40)];
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.textColor = [UIColor blueColor];

    MessageEntity *entity = [_followedTweets objectAtIndex:section];
    nameLabel.text = entity.userName;
    [avatar setImageWithURL:[NSURL URLWithString:entity.user.avatarUrl] placeholderImage:[UIImage imageNamed:@"photo-placeholder.png"]];
    [headerView addSubview:avatar];
    [headerView addSubview:nameLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
}

- (void)displayWithMediaFiles:(NSMutableArray *)media
{
    NSLog(@"refresh");
    _followedTweets = media;
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [self finishedLoading];
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

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view
{
    IGManager *manager = [IGManager sharedInstance];
    if (manager.nextUrl)
    {
        //loading = YES;
        [manager startOperationWithRequesType:GET_MORE_FEED];
    }
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
