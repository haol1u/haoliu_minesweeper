//
//  BaseViewController.m
//  HLMineSweeper
//
//  Created by Hao Liu on 7/19/15.
//  Copyright (c) 2015 Hao Liu. All rights reserved.
//

#import "BaseViewController.h"

static CGFloat const kNavigationBarPortraitHeight = 44.0;

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.hideNavigationBar = NO;
        self.hasTransparentBackground = NO;
        [self enableViewNotifications];
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:self.maxViewFrame];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:self.hideNavigationBar animated:animated];
    self.view.frame = [self maxViewFrame];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.clipsToBounds = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)enableViewNotifications
{
    // Add basic notifications for base view controller
}

- (CGRect) maxViewFrame
{
    CGRect maxFrame = [UIScreen mainScreen].applicationFrame;
    maxFrame.origin = CGPointZero;
    
    if (self.navigationController && self.hideNavigationBar == NO)
    {
        maxFrame.size.height -= kNavigationBarPortraitHeight;
    }
    
    maxFrame.size.height += [UIApplication sharedApplication].statusBarFrame.size.height;
    
    return maxFrame;
}

@end

