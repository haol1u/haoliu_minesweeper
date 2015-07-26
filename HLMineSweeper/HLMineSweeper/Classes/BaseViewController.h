//
//  BaseViewController.h
//  HLMineSweeper
//
//  Created by Hao Liu on 7/19/15.
//  Copyright (c) 2015 Hao Liu. All rights reserved.
//

@interface BaseViewController : UIViewController

@property (nonatomic, assign, readwrite) BOOL hasTransparentBackground;
@property (nonatomic, assign, readwrite) BOOL hideNavigationBar;

- (CGRect)maxViewFrame;

@end

