//
//  ProfileViewController.h
//  FakeInstagram
//
//  Created by Line_Hu on 14-2-21.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGManager.h"
#import "PersonProfileCell.h"
#import "GallaryCell.h"
#import "UIImageView+AFNetworking.h"
#import "LoadMoreTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

@interface ProfileViewController : UICollectionViewController<ParsePersonInfoDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,LoadMoreTableFooterDelegate,EGORefreshTableHeaderDelegate>
{
    LoadMoreTableFooterView *loadMoreFooter;
    EGORefreshTableHeaderView *refreshHeader;
    BOOL loading;
}
@property (strong, nonatomic) Users *user;
@property (strong, nonatomic) MessageEntity *entity;
@property (strong, nonatomic) NSMutableArray *userTweets;
@end
