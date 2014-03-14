//
//  TweetsViewController.m
//  FakeInstagram
//
//  Created by Line_Hu on 14-3-10.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import "TweetsViewController.h"
#import "SVProgressHUD.h"
#import "CellHeightCal.h"
#import "UserInfoViewController.h"
#define FONTSIZE 13
#define SMALL_ICON_SIZE 12
@interface TweetsViewController ()
{
    
}
@end

@implementation TweetsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tweets = [NSMutableArray array];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)refreshAction
{
    
}

- (void)like
{
    
}

- (void)comment
{
    
}

#pragma mark - TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_tweets count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    return 350.0;
    //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    MessageEntity *entity = [_tweets objectAtIndex:indexPath.section];
    return [CellHeightCal calculateCellHeightWithMessage:entity andComments:entity.comments];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idf = [NSString stringWithFormat:@"Cell%d",indexPath.section];
    TweetContentCell *cell = [tableView dequeueReusableCellWithIdentifier:idf];
    CGFloat buttonPostion = 300;
    if(cell == nil)
    {
        cell = [[TweetContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idf];
        if(_tweets)
        {
            MessageEntity *entity = [_tweets objectAtIndex:indexPath.section];
            //NSLog(@"tweet:%@",entity.tweetMessage);
            UIImageView *tweetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
            tweetImageView.contentMode = UIViewContentModeScaleToFill;
            [tweetImageView setImageWithURL:[NSURL URLWithString:entity.imageUrl] placeholderImage:[UIImage imageNamed:@"photo-placeholder.png"]];
            [cell addSubview:tweetImageView];
            //[cell.tweetImageView setImageWithURL:[NSURL URLWithString:entity.imageUrl] placeholderImage:[UIImage imageNamed:@"photo-placeholder.png"]];
            //Comments *comment = [entity.comments objectAtIndex:indexPath.row];
            
            //有帖子内容
            if ([entity.tweetMessage length] > 0)
            {
                NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:FONTSIZE]};
                CGSize size = [entity.tweetMessage boundingRectWithSize:CGSizeMake(300, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                UIImageView *messageIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message.png"]];
                messageIcon.frame = CGRectMake(2, 0+300+2, SMALL_ICON_SIZE, SMALL_ICON_SIZE);
                UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300, 300, size.height)];
                [cell addSubview:messageIcon];
                [cell addSubview:messageLabel];
                messageLabel.numberOfLines = 0;
                messageLabel.font = [UIFont systemFontOfSize:FONTSIZE];
                messageLabel.text = entity.tweetMessage;
                buttonPostion += size.height;
                //有点赞
                if(entity.numberOfLikes > 0)
                {
                    UILabel *likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300+size.height, 300, 20)];
                    likeLabel.numberOfLines = 0;
                    likeLabel.font = [UIFont systemFontOfSize:FONTSIZE];
                    likeLabel.text = [NSString stringWithFormat:@"%d 条称赞",entity.numberOfLikes];
                    UIImageView *likesIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"like.png"]];
                    likesIcon.frame = CGRectMake(2, 0+300+size.height+4, SMALL_ICON_SIZE, SMALL_ICON_SIZE);
                    [cell addSubview:likesIcon];
                    buttonPostion += 20;
                    [cell addSubview:likeLabel];
                    //有评论
                    if([entity.comments count] == 1)
                    {
                        Comments *comment = [entity.comments objectAtIndex:0];
                        CGSize commentSize = [comment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                        UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300+size.height+20, 300, commentSize.height)];
                        commentLabel1.numberOfLines = 0;
                        commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                        NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                        [commentText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [comment.userName length])];
                        commentLabel1.attributedText = commentText;
                        buttonPostion += commentSize.height;
                        [cell addSubview:commentLabel1];
                    }
                    else if ([entity.comments count] == 2)
                    {
                        for (int i = 0; i<=1; i++)
                        {
                            Comments *previousComment = nil;
                            Comments *comment = [entity.comments objectAtIndex:i];
                            if(i == 1)
                            {
                                previousComment = [entity.comments objectAtIndex:i-1];
                            }
                            CGSize commentSize = [comment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                            CGSize preCommentSize = [previousComment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                            UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300+size.height+20+preCommentSize.height, 300, commentSize.height)];
                            commentLabel1.numberOfLines = 0;
                            commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                            NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                            [commentText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [comment.userName length])];
                            commentLabel1.attributedText = commentText;
                            [cell addSubview:commentLabel1];
                            buttonPostion += commentSize.height;
                        }
                    }
                    else if ([entity.comments count] >= 3)
                    {
                        for (int i = 0; i<=2; i++)
                        {
                            Comments *previousComment = nil;
                            Comments *firstComment = [entity.comments firstObject];
                            CGSize firstCommentSize = [firstComment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                            if(i >= 1)
                            {
                                previousComment = [entity.comments objectAtIndex:i-1];
                            }
                            
                            Comments *comment = [entity.comments objectAtIndex:i];
                            CGSize commentSize = [comment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                            CGSize preCommentSize = [previousComment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                            UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300+size.height+20+preCommentSize.height, 300, commentSize.height)];
                            if(i ==2)
                            {
                                commentLabel1.frame = CGRectMake(20, 0+300+size.height+20+preCommentSize.height+firstCommentSize.height, 300, commentSize.height);
                            }
                            commentLabel1.numberOfLines = 0;
                            commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                            //NSLog(@"comment:%@",comment.commentContent);
                            NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                            [commentText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [comment.userName length])];
                            commentLabel1.attributedText = commentText;
                            [cell addSubview:commentLabel1];
                            buttonPostion += commentSize.height;
                        }
                    }
                    
                }
                //有内容但没点赞
                else
                {
                    //有评论
                    if([entity.comments count] == 1)
                    {
                        Comments *comment = [entity.comments objectAtIndex:0];
                        CGSize commentSize = [comment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                        UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300+size.height, 300, commentSize.height)];
                        commentLabel1.numberOfLines = 0;
                        commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                        NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                        [commentText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [comment.userName length])];
                        commentLabel1.attributedText = commentText;
                        buttonPostion += commentSize.height;
                        [cell addSubview:commentLabel1];
                    }
                    else if ([entity.comments count] == 2)
                    {
                        for (int i = 0; i<=1; i++)
                        {
                            Comments *previousComment = nil;
                            Comments *comment = [entity.comments objectAtIndex:i];
                            if(i == 1)
                            {
                                previousComment = [entity.comments objectAtIndex:i-1];
                            }
                            CGSize commentSize = [comment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                            CGSize preCommentSize = [previousComment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                            UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300+size.height+preCommentSize.height, 300, commentSize.height)];
                            commentLabel1.numberOfLines = 0;
                            commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                            NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                            [commentText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [comment.userName length])];
                            commentLabel1.attributedText = commentText;
                            buttonPostion += commentSize.height;
                            [cell addSubview:commentLabel1];
                        }
                    }
                    else if ([entity.comments count] >= 3)
                    {
                        for (int i = 0; i<=2; i++)
                        {
                            Comments *previousComment = nil;
                            Comments *firstComment = [entity.comments firstObject];
                            CGSize firstCommentSize = [firstComment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                            if(i >= 1)
                            {
                                previousComment = [entity.comments objectAtIndex:i-1];
                            }
                            
                            Comments *comment = [entity.comments objectAtIndex:i];
                            CGSize commentSize = [comment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                            CGSize preCommentSize = [previousComment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                            UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300+size.height+preCommentSize.height, 300, commentSize.height)];
                            if(i ==2)
                            {
                                commentLabel1.frame = CGRectMake(20, 0+300+size.height+preCommentSize.height+firstCommentSize.height, 300, commentSize.height);
                            }
                            commentLabel1.numberOfLines = 0;
                            commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                            //NSLog(@"comment:%@",comment.commentContent);
                            NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                            [commentText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [comment.userName length])];
                            commentLabel1.attributedText = commentText;
                            [cell addSubview:commentLabel1];
                            buttonPostion += commentSize.height;
                            
                        }
                    }
                    
                }
            }
            //没帖子内容
            else
            {
                NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:FONTSIZE]};
                //有点赞
                if(entity.numberOfLikes > 0)
                {
                    UILabel *likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300, 300, 20)];
                    likeLabel.numberOfLines = 0;
                    likeLabel.font = [UIFont systemFontOfSize:FONTSIZE];
                    likeLabel.text = [NSString stringWithFormat:@"%d 条称赞",entity.numberOfLikes];
                    UIImageView *likesIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"like.png"]];
                    likesIcon.frame = CGRectMake(2, 0+300+4, SMALL_ICON_SIZE, SMALL_ICON_SIZE);
                    [cell addSubview:likesIcon];
                    [cell addSubview:likeLabel];
                    buttonPostion += 20;
                    
                    //有评论
                    if([entity.comments count] == 1)
                    {
                        Comments *comment = [entity.comments objectAtIndex:0];
                        CGSize commentSize = [comment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                        UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300+20, 300, commentSize.height)];
                        commentLabel1.numberOfLines = 0;
                        commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                        NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                        [commentText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [comment.userName length])];
                        commentLabel1.attributedText = commentText;
                        buttonPostion += commentSize.height;
                        [cell addSubview:commentLabel1];
                    }
                    else if ([entity.comments count] == 2)
                    {
                        for (int i = 0; i<=1; i++)
                        {
                            Comments *previousComment = nil;
                            Comments *comment = [entity.comments objectAtIndex:i];
                            if(i == 1)
                            {
                                previousComment = [entity.comments objectAtIndex:i-1];
                            }
                            CGSize commentSize = [comment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                            CGSize preCommentSize = [previousComment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                            UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300+20+preCommentSize.height, 300, commentSize.height)];
                            commentLabel1.numberOfLines = 0;
                            commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                            NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                            [commentText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [comment.userName length])];
                            commentLabel1.attributedText = commentText;
                            buttonPostion += commentSize.height;
                            [cell addSubview:commentLabel1];
                        }
                    }
                    else if ([entity.comments count] >= 3)
                    {
                        for (int i = 0; i<=2; i++)
                        {
                            Comments *previousComment = nil;
                            Comments *firstComment = [entity.comments firstObject];
                            CGSize firstCommentSize = [firstComment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                            if(i >= 1)
                            {
                                previousComment = [entity.comments objectAtIndex:i-1];
                            }
                            
                            Comments *comment = [entity.comments objectAtIndex:i];
                            CGSize commentSize = [comment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                            CGSize preCommentSize = [previousComment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                            UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300+20+preCommentSize.height, 300, commentSize.height)];
                            if(i == 2)
                            {
                                commentLabel1.frame = CGRectMake(20, 0+300+20+preCommentSize.height+firstCommentSize.height, 300, commentSize.height);
                            }
                            commentLabel1.numberOfLines = 0;
                            commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                            //NSLog(@"comment:%@",comment.commentContent);
                            NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                            [commentText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [comment.userName length])];
                            commentLabel1.attributedText = commentText;
                            [cell addSubview:commentLabel1];
                            buttonPostion += commentSize.height;
                        }
                    }
                    
                }
                //没点赞
                else
                {
                    //但是有评论
                    if([entity.comments count] == 1)
                    {
                        Comments *comment = [entity.comments objectAtIndex:0];
                        CGSize commentSize = [comment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                        UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300, 300, commentSize.height)];
                        commentLabel1.numberOfLines = 0;
                        commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                        NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                        [commentText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [comment.userName length])];
                        commentLabel1.attributedText = commentText;
                        buttonPostion += commentSize.height;
                        [cell addSubview:commentLabel1];
                    }
                    else if ([entity.comments count] == 2)
                    {
                        for (int i = 0; i<=1; i++)
                        {
                            Comments *previousComment = nil;
                            Comments *comment = [entity.comments objectAtIndex:i];
                            if(i == 1)
                            {
                                previousComment = [entity.comments objectAtIndex:i-1];
                            }
                            CGSize commentSize = [comment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                            CGSize preCommentSize = [previousComment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                            UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300+preCommentSize.height, 300, commentSize.height)];
                            commentLabel1.numberOfLines = 0;
                            commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                            NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                            [commentText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [comment.userName length])];
                            commentLabel1.attributedText = commentText;
                            buttonPostion += commentSize.height;
                            [cell addSubview:commentLabel1];
                        }
                    }
                    else if ([entity.comments count] >= 3)
                    {
                        for (int i = 0; i<=2; i++)
                        {
                            Comments *previousComment = nil;
                            Comments *firstComment = [entity.comments firstObject];
                            CGSize firstCommentSize = [firstComment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                            if(i >= 1)
                            {
                                previousComment = [entity.comments objectAtIndex:i-1];
                            }
                            
                            Comments *comment = [entity.comments objectAtIndex:i];
                            CGSize commentSize = [comment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                            CGSize preCommentSize = [previousComment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                            UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0+300+preCommentSize.height, 300, commentSize.height)];
                            commentLabel1.numberOfLines = 0;
                            if(i ==2)
                            {
                                commentLabel1.frame = CGRectMake(20, 0+300+preCommentSize.height+firstCommentSize.height, 300, commentSize.height);
                            }
                            commentLabel1.numberOfLines = 0;
                            commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                            //NSLog(@"comment:%@",comment.commentContent);
                            NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                            [commentText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [comment.userName length])];
                            commentLabel1.attributedText = commentText;
                            buttonPostion += commentSize.height;
                            [cell addSubview:commentLabel1];
                        }
                    }
                }
            }
        }
        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        commentButton.frame = CGRectMake(20, buttonPostion, 40, 30);
        [commentButton setTitle:@"评论" forState:UIControlStateNormal];
        commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [commentButton addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:commentButton];
        UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        likeButton.frame = CGRectMake(70, buttonPostion, 40, 30);
        [likeButton setTitle:@"赞" forState:UIControlStateNormal];
        [cell addSubview:likeButton];
        [likeButton addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 30, 30)];
    avatar.layer.cornerRadius = 15;
    avatar.layer.masksToBounds = YES;
    UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nameButton.tag = section;
    nameButton.frame = CGRectMake(5+avatar.frame.size.width+5, 0, 130, 40);
    nameButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [nameButton addTarget:self action:@selector(showUserInfoController:) forControlEvents:UIControlEventTouchUpInside];
    /* 注意UIButton的title设置左对齐的方式，设置textAlignment是无效的*/
    //nameButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    nameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5+avatar.frame.size.width+5 + 190, 5, 85, 30)];
    timeLabel.font = [UIFont systemFontOfSize:13];
    
    MessageEntity *entity = [_tweets objectAtIndex:section];
    [nameButton setTitle:entity.userName forState:UIControlStateNormal];
    NSUInteger timeInterVal = entity.createdTime;
    NSTimeInterval timeInterValSinceNow = [Common timeIntervalSinceCreatedDate:timeInterVal];
    //NSLog(@"inter:%.0f,%d,%@",timeInterValSinceNow,timeInterVal,entity.userName);
    if(timeInterValSinceNow < 60)
    {
        timeLabel.text = [NSString stringWithFormat:@"%.0f秒",timeInterValSinceNow];
    }
    //4210%60
    else if(timeInterValSinceNow/3600 < 1)
    {
        NSInteger minutes = timeInterValSinceNow/60;
        NSInteger seconds = (NSInteger)timeInterValSinceNow%60;
        timeLabel.text = [NSString stringWithFormat:@"%d分%d秒",minutes,seconds];
    }
    else
    {
        NSInteger hour = timeInterValSinceNow/3600;
        if(hour >= 24)
        {
            timeLabel.text = [NSString stringWithFormat:@"%d天前",hour/24];
        }
        else
        {
            NSInteger minutes = timeInterValSinceNow / 60 -60*hour;
            timeLabel.text = [NSString stringWithFormat:@"%d小时%d分",hour,minutes];
        }
        
    }
    [headerView addSubview:timeLabel];
    [avatar setImageWithURL:[NSURL URLWithString:entity.user.avatarUrl] placeholderImage:[UIImage imageNamed:@"photo-placeholder.png"]];
    [headerView addSubview:avatar];
    [headerView addSubview:nameButton];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
}


#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[loadMoreFooter egoRefreshScrollViewDidScroll:scrollView];
    [refreshHeader egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[loadMoreFooter egoRefreshScrollViewDidEndDragging:scrollView];
	[refreshHeader egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - Loading Control

- (void)displayWithMediaFiles:(NSMutableArray *)media
{
    NSLog(@"refresh");
    [SVProgressHUD dismiss];
    _tweets = media;
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [self.refreshControl endRefreshing];
    [self finishedLoading];
}

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view
{
    
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    
}

- (void)finishedLoading
{
    [loadMoreFooter egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [refreshHeader egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (void)showUserInfoController:(id)sender;
{
    UIButton *button = (UIButton *)sender;
    MessageEntity *entity = [_tweets objectAtIndex:button.tag];
    Users *user = entity.user;
    UserInfoViewController *userInfoVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UserInfo"];
    userInfoVC.userID = user.userID;
    [self.navigationController pushViewController:userInfoVC animated:YES];
    NSLog(@"showUser:%d",user.userID);
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