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
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define R 51
#define G 116
#define B 219

@interface TweetsViewController ()
{
    NSRegularExpression *topicRegex;
    NSRegularExpression *atSignRegex;
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
    if(topicRegex == nil || atSignRegex  == nil)
    {
        topicRegex = [[NSRegularExpression alloc] initWithPattern:@"#([^#|\\W]+)" options:NSRegularExpressionCaseInsensitive error:nil];
        atSignRegex = [[NSRegularExpression alloc] initWithPattern:@"@\\w+" options:NSRegularExpressionCaseInsensitive error:nil];
    }
}

- (void)updateCommentString:(NSString *)text withRegexExp:(NSRegularExpression *)regex resultString:(NSMutableAttributedString *)attString
{
    NSArray *matchs = [regex matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    if([matchs count] > 0)
    {
        for (NSTextCheckingResult *result in matchs)
        {
            NSRange matchRange = result.range;
            [attString addAttribute:NSForegroundColorAttributeName value:COLOR(R, G, B, 1) range:matchRange];
        }
    }
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

- (void)userButtonPressed:(id)sender
{
    //NSLog(@"name pressed");
    UIButton *button = (UIButton *)sender;
    NSInteger userID = button.tag;
    NSLog(@"user:%d",userID);
    UserInfoViewController *userInfoVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UserInfo"];
    userInfoVC.userID = userID;
    [self.navigationController pushViewController:userInfoVC animated:YES];
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
    }
    for (UIView *view in [cell.contentView subviews])
    {
        [view removeFromSuperview];
    }
    if(_tweets)
    {
        //#符号，后面可匹配一个#符号和一个
        MessageEntity *entity = [self.tweets objectAtIndex:indexPath.section];
        UIImageView *tweetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
        tweetImageView.contentMode = UIViewContentModeScaleToFill;
        [tweetImageView setImageWithURL:[NSURL URLWithString:entity.imageUrl] placeholderImage:[UIImage imageNamed:@"photo-placeholder.png"]];
        [cell.contentView addSubview:tweetImageView];
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
            [cell.contentView addSubview:messageIcon];
            [cell.contentView addSubview:messageLabel];
            messageLabel.numberOfLines = 0;
            messageLabel.font = [UIFont systemFontOfSize:FONTSIZE];
            NSMutableAttributedString *attMessage = [[NSMutableAttributedString alloc] initWithString:entity.tweetMessage];
            //messageLabel.text = entity.tweetMessage;
            buttonPostion += size.height;
            [self updateCommentString:entity.tweetMessage withRegexExp:topicRegex resultString:attMessage];
            [self updateCommentString:entity.tweetMessage withRegexExp:atSignRegex resultString:attMessage];
            messageLabel.attributedText = attMessage;
            //有点赞
            if(entity.numberOfLikes > 0)
            {
                UILabel *likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300+size.height, 300, 20)];
                likeLabel.numberOfLines = 0;
                likeLabel.font = [UIFont systemFontOfSize:FONTSIZE];
                likeLabel.text = [NSString stringWithFormat:@"%d 条称赞",entity.numberOfLikes];
                UIImageView *likesIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"like.png"]];
                likesIcon.frame = CGRectMake(2, 0+300+size.height+4, SMALL_ICON_SIZE, SMALL_ICON_SIZE);
                [cell.contentView addSubview:likesIcon];
                buttonPostion += 20;
                [cell.contentView addSubview:likeLabel];
                //有评论
                if([entity.comments count] == 1)
                {
                    Comments *comment = [entity.comments objectAtIndex:0];
                    CGSize commentSize = [comment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                    UIButton *userNameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    CGSize nameStringSize = [comment.userName boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
                    userNameBtn.frame = CGRectMake(20, 0+300+size.height+20, nameStringSize.width, 20);
                    [userNameBtn addTarget:self action:@selector(userButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300+size.height+20, 300, commentSize.height)];
                    commentLabel1.numberOfLines = 0;
                    commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                    NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                    [commentText addAttribute:NSForegroundColorAttributeName value:COLOR(R, G, B, 1) range:NSMakeRange(0, [comment.userName length])];
                    [self updateCommentString:commentText.mutableString withRegexExp:topicRegex resultString:commentText];
                    [self updateCommentString:commentText.mutableString withRegexExp:atSignRegex resultString:commentText];
                    userNameBtn.tag = comment.userID;
                    commentLabel1.attributedText = commentText;
                    buttonPostion += commentSize.height;
                    [cell.contentView addSubview:userNameBtn];
                    [cell.contentView addSubview:commentLabel1];
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
                        
                        UIButton *userNameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        CGSize nameStringSize = [comment.userName boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
                        userNameBtn.frame = CGRectMake(20, 0+300+size.height+20+preCommentSize.height, nameStringSize.width, 20);
                        [userNameBtn addTarget:self action:@selector(userButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                        userNameBtn.tag = comment.userID;
                        
                        UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300+size.height+20+preCommentSize.height, 300, commentSize.height)];
                        commentLabel1.numberOfLines = 0;
                        commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                        NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                        [commentText addAttribute:NSForegroundColorAttributeName value:COLOR(R, G, B, 1) range:NSMakeRange(0, [comment.userName length])];
                        [self updateCommentString:commentText.mutableString withRegexExp:topicRegex resultString:commentText];
                        [self updateCommentString:commentText.mutableString withRegexExp:atSignRegex resultString:commentText];
                        commentLabel1.attributedText = commentText;
                        [cell.contentView addSubview:userNameBtn];
                        [cell.contentView addSubview:commentLabel1];
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
                        
                        UIButton *userNameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        CGSize nameStringSize = [comment.userName boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
                        userNameBtn.frame = CGRectMake(20, 0+300+size.height+20+preCommentSize.height, nameStringSize.width, 20);
                        [userNameBtn addTarget:self action:@selector(userButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                        //userNameBtn.backgroundColor = [UIColor redColor];
                        userNameBtn.tag = comment.userID;
                        
                        UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300+size.height+20+preCommentSize.height, 300, commentSize.height)];
                        if(i ==2)
                        {
                            commentLabel1.frame = CGRectMake(20, 0+300+size.height+20+preCommentSize.height+firstCommentSize.height, 300, commentSize.height);
                            userNameBtn.frame = CGRectMake(20, 0+300+size.height+20+preCommentSize.height+firstCommentSize.height, nameStringSize.width, 20);
                        }
                        commentLabel1.numberOfLines = 0;
                        commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                        //NSLog(@"comment:%@",comment.commentContent);
                        NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                        [commentText addAttribute:NSForegroundColorAttributeName value:COLOR(R, G, B, 1) range:NSMakeRange(0, [comment.userName length])];
                        [self updateCommentString:commentText.mutableString withRegexExp:topicRegex resultString:commentText];
                        [self updateCommentString:commentText.mutableString withRegexExp:atSignRegex resultString:commentText];
                        commentLabel1.attributedText = commentText;
                        
                        [cell.contentView addSubview:userNameBtn];
                        
                        [cell.contentView addSubview:commentLabel1];
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
                    UIButton *userNameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    CGSize nameStringSize = [comment.userName boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
                    userNameBtn.frame = CGRectMake(20, 0+300+size.height+20, nameStringSize.width, 20);
                    [userNameBtn addTarget:self action:@selector(userButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    userNameBtn.tag = comment.userID;
                    
                    UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300+size.height, 300, commentSize.height)];
                    commentLabel1.numberOfLines = 0;
                    commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                    NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                    [commentText addAttribute:NSForegroundColorAttributeName value:COLOR(R, G, B, 1) range:NSMakeRange(0, [comment.userName length])];
                    [self updateCommentString:commentText.mutableString withRegexExp:topicRegex resultString:commentText];
                    [self updateCommentString:commentText.mutableString withRegexExp:atSignRegex resultString:commentText];
                    commentLabel1.attributedText = commentText;
                    buttonPostion += commentSize.height;
                    [cell.contentView addSubview:userNameBtn];
                    [cell.contentView addSubview:commentLabel1];
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
                        
                        UIButton *userNameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        CGSize nameStringSize = [comment.userName boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
                        userNameBtn.frame = CGRectMake(20, 0+300+size.height+20+preCommentSize.height, nameStringSize.width, 20);
                        [userNameBtn addTarget:self action:@selector(userButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                        userNameBtn.tag = comment.userID;
                        
                        UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300+size.height+preCommentSize.height, 300, commentSize.height)];
                        commentLabel1.numberOfLines = 0;
                        commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                        NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                        [commentText addAttribute:NSForegroundColorAttributeName value:COLOR(R, G, B, 1) range:NSMakeRange(0, [comment.userName length])];
                        [self updateCommentString:commentText.mutableString withRegexExp:topicRegex resultString:commentText];
                        [self updateCommentString:commentText.mutableString withRegexExp:atSignRegex resultString:commentText];
                        commentLabel1.attributedText = commentText;
                        buttonPostion += commentSize.height;
                        [cell.contentView addSubview:commentLabel1];
                        [cell.contentView addSubview:userNameBtn];
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
                        UIButton *userNameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        CGSize nameStringSize = [comment.userName boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
                        userNameBtn.frame = CGRectMake(20, 0+300+size.height+20+preCommentSize.height, nameStringSize.width, 20);
                        [userNameBtn addTarget:self action:@selector(userButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                        userNameBtn.tag = comment.userID;
                        
                        UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300+size.height+preCommentSize.height, 300, commentSize.height)];
                        if(i ==2)
                        {
                            commentLabel1.frame = CGRectMake(20, 0+300+size.height+preCommentSize.height+firstCommentSize.height, 300, commentSize.height);
                            userNameBtn.frame = CGRectMake(20, 0+300+size.height+preCommentSize.height+firstCommentSize.height, nameStringSize.width, 20);
                        }
                        commentLabel1.numberOfLines = 0;
                        commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                        //NSLog(@"comment:%@",comment.commentContent);
                        NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                        [commentText addAttribute:NSForegroundColorAttributeName value:COLOR(R, G, B, 1) range:NSMakeRange(0, [comment.userName length])];
                        [self updateCommentString:commentText.mutableString withRegexExp:topicRegex resultString:commentText];
                        [self updateCommentString:commentText.mutableString withRegexExp:atSignRegex resultString:commentText];
                        commentLabel1.attributedText = commentText;
                        [cell.contentView addSubview:userNameBtn];
                        [cell.contentView addSubview:commentLabel1];
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
                [cell.contentView addSubview:likesIcon];
                [cell.contentView addSubview:likeLabel];
                buttonPostion += 20;
                
                //有评论
                if([entity.comments count] == 1)
                {
                    Comments *comment = [entity.comments objectAtIndex:0];
                    CGSize commentSize = [comment.commentContent boundingRectWithSize:CGSizeMake(300, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                    UIButton *userNameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    CGSize nameStringSize = [comment.userName boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
                    userNameBtn.frame = CGRectMake(20, 0+300+20, nameStringSize.width, 20);
                    [userNameBtn addTarget:self action:@selector(userButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    userNameBtn.tag = comment.userID;
                    
                    UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300+20, 300, commentSize.height)];
                    commentLabel1.numberOfLines = 0;
                    commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                    NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                    [commentText addAttribute:NSForegroundColorAttributeName value:COLOR(R, G, B, 1) range:NSMakeRange(0, [comment.userName length])];
                    [self updateCommentString:commentText.mutableString withRegexExp:topicRegex resultString:commentText];
                    [self updateCommentString:commentText.mutableString withRegexExp:atSignRegex resultString:commentText];
                    commentLabel1.attributedText = commentText;
                    buttonPostion += commentSize.height;
                    [cell.contentView addSubview:userNameBtn];
                    [cell.contentView addSubview:commentLabel1];
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
                        UIButton *userNameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        CGSize nameStringSize = [comment.userName boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
                        userNameBtn.frame = CGRectMake(20, 0+300+20+preCommentSize.height, nameStringSize.width, 20);
                        [userNameBtn addTarget:self action:@selector(userButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                        userNameBtn.tag = comment.userID;
                        
                        UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300+20+preCommentSize.height, 300, commentSize.height)];
                        commentLabel1.numberOfLines = 0;
                        commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                        NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                        [commentText addAttribute:NSForegroundColorAttributeName value:COLOR(R, G, B, 1) range:NSMakeRange(0, [comment.userName length])];
                        [self updateCommentString:commentText.mutableString withRegexExp:topicRegex resultString:commentText];
                        [self updateCommentString:commentText.mutableString withRegexExp:atSignRegex resultString:commentText];
                        commentLabel1.attributedText = commentText;
                        buttonPostion += commentSize.height;
                        [cell.contentView addSubview:userNameBtn];
                        [cell.contentView addSubview:commentLabel1];
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
                        UIButton *userNameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        CGSize nameStringSize = [comment.userName boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
                        userNameBtn.frame = CGRectMake(20, 0+30020+preCommentSize.height, nameStringSize.width, 20);
                        [userNameBtn addTarget:self action:@selector(userButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                        userNameBtn.tag = comment.userID;
                        
                        UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300+20+preCommentSize.height, 300, commentSize.height)];
                        if(i == 2)
                        {
                            commentLabel1.frame = CGRectMake(20, 0+300+20+preCommentSize.height+firstCommentSize.height, 300, commentSize.height);
                            userNameBtn.frame = CGRectMake(20, 0+300+20+preCommentSize.height+firstCommentSize.height, nameStringSize.width, 20);
                        }
                        commentLabel1.numberOfLines = 0;
                        commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                        //NSLog(@"comment:%@",comment.commentContent);
                        NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                        [commentText addAttribute:NSForegroundColorAttributeName value:COLOR(R, G, B, 1) range:NSMakeRange(0, [comment.userName length])];
                        [self updateCommentString:commentText.mutableString withRegexExp:topicRegex resultString:commentText];
                        [self updateCommentString:commentText.mutableString withRegexExp:atSignRegex resultString:commentText];
                        commentLabel1.attributedText = commentText;
                        [cell.contentView addSubview:userNameBtn];
                        [cell.contentView addSubview:commentLabel1];
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
                    UIButton *userNameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    CGSize nameStringSize = [comment.userName boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
                    userNameBtn.frame = CGRectMake(20, 0+300+20, nameStringSize.width, 20);
                    [userNameBtn addTarget:self action:@selector(userButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    userNameBtn.tag = comment.userID;
                    
                    UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300, 300, commentSize.height)];
                    commentLabel1.numberOfLines = 0;
                    commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                    NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                    [commentText addAttribute:NSForegroundColorAttributeName value:COLOR(R, G, B, 1) range:NSMakeRange(0, [comment.userName length])];
                    [self updateCommentString:commentText.mutableString withRegexExp:topicRegex resultString:commentText];
                    [self updateCommentString:commentText.mutableString withRegexExp:atSignRegex resultString:commentText];
                    commentLabel1.attributedText = commentText;
                    buttonPostion += commentSize.height;
                    [cell.contentView addSubview:userNameBtn];
                    [cell.contentView addSubview:commentLabel1];
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
                        UIButton *userNameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        CGSize nameStringSize = [comment.userName boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
                        userNameBtn.frame = CGRectMake(20, 0+300+20, nameStringSize.width, 20);
                        [userNameBtn addTarget:self action:@selector(userButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                        userNameBtn.tag = comment.userID;
                        
                        UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0+300+preCommentSize.height, 300, commentSize.height)];
                        commentLabel1.numberOfLines = 0;
                        commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                        NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                        [commentText addAttribute:NSForegroundColorAttributeName value:COLOR(R, G, B, 1) range:NSMakeRange(0, [comment.userName length])];
                        [self updateCommentString:commentText.mutableString withRegexExp:topicRegex resultString:commentText];
                        [self updateCommentString:commentText.mutableString withRegexExp:atSignRegex resultString:commentText];
                        commentLabel1.attributedText = commentText;
                        buttonPostion += commentSize.height;
                        [cell.contentView addSubview:userNameBtn];
                        [cell.contentView addSubview:commentLabel1];
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
                        UIButton *userNameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        CGSize nameStringSize = [comment.userName boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
                        userNameBtn.frame = CGRectMake(20, 0+300+20, nameStringSize.width, 20);
                        [userNameBtn addTarget:self action:@selector(userButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                        userNameBtn.tag = comment.userID;
                        
                        UILabel *commentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0+300+preCommentSize.height, 300, commentSize.height)];
                        commentLabel1.numberOfLines = 0;
                        if(i ==2)
                        {
                            commentLabel1.frame = CGRectMake(20, 0+300+preCommentSize.height+firstCommentSize.height, 300, commentSize.height);
                            userNameBtn.frame = CGRectMake(20, 0+300+preCommentSize.height+firstCommentSize.height, nameStringSize.width, 20);
                        }
                        commentLabel1.numberOfLines = 0;
                        commentLabel1.font = [UIFont systemFontOfSize:FONTSIZE];
                        //NSLog(@"comment:%@",comment.commentContent);
                        NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",comment.userName,comment.commentContent]];
                        [commentText addAttribute:NSForegroundColorAttributeName value:COLOR(R, G, B, 1) range:NSMakeRange(0, [comment.userName length])];
                        [self updateCommentString:commentText.mutableString withRegexExp:topicRegex resultString:commentText];
                        [self updateCommentString:commentText.mutableString withRegexExp:atSignRegex resultString:commentText];
                        commentLabel1.attributedText = commentText;
                        buttonPostion += commentSize.height;
                        [cell.contentView addSubview:userNameBtn];
                        [cell.contentView addSubview:commentLabel1];
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
    [cell.contentView addSubview:commentButton];
    UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    likeButton.frame = CGRectMake(70, buttonPostion, 40, 30);
    [likeButton setTitle:@"赞" forState:UIControlStateNormal];
    [cell.contentView addSubview:likeButton];
    [likeButton addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];

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
    self.tweets = media;
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [self.refreshControl endRefreshing];
    [self finishedLoading];
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
