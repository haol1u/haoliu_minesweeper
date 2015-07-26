//
//  GameManager.h
//  HLMineSweeper
//
//  Created by Hao Liu on 7/20/15.
//  Copyright (c) 2015 Hao Liu. All rights reserved.
//

#import "MineSweeperGame.h"

@interface GameManager : NSObject

@property (nonatomic, strong, readonly) MineSweeperGame *currentGame;

+ (instancetype) sharedManager;

- (void) switchToEasyMode;
- (void) switchToIntermediateMode;
- (void) switchToHardMode;

@end
