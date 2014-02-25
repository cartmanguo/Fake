//
//  LoginViewController.h
//  FakeInstagram
//
//  Created by Line_Hu on 14-2-20.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#define kToken @"myToken"
#import <UIKit/UIKit.h>
#import "MainPageViewController.h"
@interface LoginViewController : UIViewController<UIWebViewDelegate>
{
    UIWebView *webView;
}
@property (strong, nonatomic) NSString *token;

@end
