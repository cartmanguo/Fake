//
//  PersonProfileCell.h
//  FakeInstagram
//
//  Created by Line_Hu on 14-2-21.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonProfileCell : UITableViewCell
{
    
}
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followedLabel;

@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@end
