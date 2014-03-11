//
//  UserInfoViewController.h
//  FakeInstagram
//
//  Created by Line_Hu on 14-3-11.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import "ProfileViewController.h"

@interface UserInfoViewController : ProfileViewController
{
    IGManager *manager;
}
@property (assign, nonatomic) NSInteger userID;
@property (strong, nonatomic) Users *user;
- (id)initWithUserID:(NSInteger)userID layoutStyle:(UICollectionViewFlowLayout *)layout;
@end
