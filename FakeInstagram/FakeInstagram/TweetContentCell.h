//
//  TweetContentCell.h
//  FakeInstagram
//
//  Created by Line_Hu on 14-2-28.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetContentCell : UITableViewCell
{
    
}
@property (strong, nonatomic) UIImageView *tweetImageView;
@property (strong, nonatomic) UILabel *likesLabel;
@property (strong, nonatomic) UILabel *commentsLabel;
@property (strong, nonatomic) UILabel *messageLabel;

@end
