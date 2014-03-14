//
//  RaisedButtonTabbarViewController.m
//  FakeInstagram
//
//  Created by Line_Hu on 14-3-14.
//  Copyright (c) 2014年 Alpha. All rights reserved.
//

#import "RaisedButtonTabbarViewController.h"

@interface RaisedButtonTabbarViewController ()

@end

@implementation RaisedButtonTabbarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    [button addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)takePicture
{
    NSLog(@"take picture");
    SCNavigationController *camera = [[SCNavigationController alloc] init];
    camera.scNaigationDelegate = self;
    [camera showCameraWithParentController:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addCenterButtonWithImage:[UIImage imageNamed:@"Camera.png"] highlightImage:[UIImage imageNamed:@"Camera.png"]];
	// Do any additional setup after loading the view.
}

- (BOOL)willDismissNavigationController:(SCNavigationController*)navigatonController
{
    return YES;
}

- (void)didTakePicture:(SCNavigationController*)navigationController image:(UIImage*)image
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
