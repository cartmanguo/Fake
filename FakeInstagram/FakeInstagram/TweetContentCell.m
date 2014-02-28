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
        CGRect imageFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 300);
        self.tweetImageView = [[UIImageView alloc] initWithFrame:imageFrame];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.origin.y + _tweetImageView.frame.size.height, 280, 40)];
        _messageLabel.font = [UIFont systemFontOfSize:12];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textColor = [UIColor blackColor];
        [self addSubview:_tweetImageView];
        [self addSubview:_messageLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
