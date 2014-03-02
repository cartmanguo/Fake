//
//  TweetContentCell.h
//  FakeInstagram
//
//  Created by Line_Hu on 14-2-28.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageEntity.h"
@interface TweetContentCell : UITableViewCell
{
    
}
@property (strong, nonatomic) MessageEntity *message;
@property (strong, nonatomic) NSMutableArray *comments;
@property (strong, nonatomic) UIImageView *tweetImageView;
@property (strong, nonatomic) UILabel *likesLabel;
@property (strong, nonatomic) UILabel *commentsLabel1;
@property (strong, nonatomic) UILabel *commentsLabel2;
@property (strong, nonatomic) UILabel *commentsLabel3;
@property (strong, nonatomic) UILabel *messageLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Message:(MessageEntity *)message andComments:(NSMutableArray *)comments;
- (void)calculateCellHeightWithMessage:(MessageEntity *)message andComments:(NSMutableArray *)comments;
@end
