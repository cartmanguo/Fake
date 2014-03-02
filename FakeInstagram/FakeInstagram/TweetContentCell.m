//
//  TweetContentCell.m
//  FakeInstagram
//
//  Created by Line_Hu on 14-2-28.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import "TweetContentCell.h"

@implementation TweetContentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        CGRect imageFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 300);
//        self.tweetImageView = [[UIImageView alloc] initWithFrame:imageFrame];
//        [self addSubview:_tweetImageView];
//
//        _likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.origin.y + _tweetImageView.frame.size.height, 180, 20)];
//        _likesLabel.font = [UIFont systemFontOfSize:13];
//        _likesLabel.numberOfLines = 0;
//        [self addSubview:_likesLabel];
//        
//        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.origin.y + _tweetImageView.frame.size.height +10, 280, 40)];
//        _messageLabel.font = [UIFont systemFontOfSize:12];
//        _messageLabel.numberOfLines = 0;
//        _messageLabel.textColor = [UIColor blackColor];
//        [self addSubview:_messageLabel];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Message:(MessageEntity *)message andComments:(NSMutableArray *)comments
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _message = message;
        _comments = comments;
        CGRect imageFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 300);
        self.tweetImageView = [[UIImageView alloc] initWithFrame:imageFrame];
        [self addSubview:_tweetImageView];
        //[self calculateCellHeightWithMessage:_message andComments:_comments];
    }
    return self;
}

- (void)calculateCellHeightWithMessage:(MessageEntity *)message andComments:(NSMutableArray *)comments
{
    if (message.numberOfLikes > 0)
    {
        _likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.origin.y + _tweetImageView.frame.size.height, 180, 20)];
        _likesLabel.font = [UIFont systemFontOfSize:12];
        _likesLabel.numberOfLines = 0;
        [self addSubview:_likesLabel];
    }

    if([message.tweetMessage length] > 0)
    {
        NSString *tweetMessage = message.tweetMessage;
        UIFont *textFont = [UIFont systemFontOfSize:12];
        CGSize textSize = [tweetMessage sizeWithFont:textFont constrainedToSize:CGSizeMake(320, 44) lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat textHeight = textSize.height;
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.origin.y + _tweetImageView.frame.size.height + _likesLabel.frame.size.height, 280, textHeight)];
        _messageLabel.font = [UIFont systemFontOfSize:12];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textColor = [UIColor blackColor];
        [self addSubview:_messageLabel];
    }
    if(comments)
    {
        if([comments count] == 1)
        {
            Comments *comment = [comments objectAtIndex:0];
            if([comment.commentContent length] > 0)
            {
                NSString *commentContent = comment.commentContent;
                UIFont *textFont = [UIFont systemFontOfSize:13];
                CGSize textSize = [commentContent sizeWithFont:textFont constrainedToSize:CGSizeMake(320, 44) lineBreakMode:NSLineBreakByWordWrapping];
                CGFloat textHeight = textSize.height;
                self.commentsLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.origin.y + _tweetImageView.frame.size.height + _messageLabel.frame.size.height, 320, textHeight)];
                [self addSubview:_commentsLabel1];
            }
            
        }
        else if([comments count] == 2)
        {
            Comments *comment = [comments objectAtIndex:0];
            if([comment.commentContent length] > 0)
            {
                for (int i = 0; i<=2; i++)
                {
                    Comments *comment = [comments objectAtIndex:i];
                    if([comment.commentContent length] > 0)
                    {
                        NSString *commentContent = comment.commentContent;
                        UIFont *textFont = [UIFont systemFontOfSize:13];
                        CGSize textSize = [commentContent sizeWithFont:textFont constrainedToSize:CGSizeMake(320, 44) lineBreakMode:NSLineBreakByWordWrapping];
                        CGFloat textHeight = textSize.height;
                        self.commentsLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.origin.y + _tweetImageView.frame.size.height + _messageLabel.frame.size.height+_commentsLabel1.frame.size.height, 320, textHeight)];
                        [self addSubview:_commentsLabel2];
                    }
                    
                }
            }
            
        }
        else if([comments count] >= 3)
        {
            for (int i = 0; i<=2; i++)
            {
                Comments *comment = [comments objectAtIndex:i];
                if([comment.commentContent length] > 0)
                {
                    NSString *commentContent = comment.commentContent;
                    UIFont *textFont = [UIFont systemFontOfSize:13];
                    CGSize textSize = [commentContent sizeWithFont:textFont constrainedToSize:CGSizeMake(320, 44) lineBreakMode:NSLineBreakByWordWrapping];
                    CGFloat textHeight = textSize.height;
                    self.commentsLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.origin.y + _tweetImageView.frame.size.height + _messageLabel.frame.size.height+_commentsLabel1.frame.size.height + _commentsLabel2.frame.size.height, 320, textHeight)];
                    [self addSubview:_commentsLabel3];
                }
                
            }
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
