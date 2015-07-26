//
//  GameManager.m
//  HLMineSweeper
//
//  Created by Hao Liu on 7/20/15.
//  Copyright (c) 2015 Hao Liu. All rights reserved.
//

#import "GameManager.h"

@interface GameManager()

@property (nonatomic, strong, readwrite) MineSweeperGame *currentGame;

@end

@implementation GameManager

+ (instancetype) sharedManager {
    static GameManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype) init
{
    if (self = [super init])
    {
        self.currentGame = [MineSweeperGame createMineSweeperGameInEasyMode];
    }
    
    return self;
}

- (void) switchToEasyMode
{
    self.currentGame = [MineSweeperGame createMineSweeperGameInEasyMode];
}

- (void) switchToIntermediateMode
{
    self.currentGame = [MineSweeperGame createMineSweeperGameInIntermediateMode];
}

- (void) switchToHardMode
{
    self.currentGame = [MineSweeperGame createMineSweeperGameInHardMode];
}

@end
