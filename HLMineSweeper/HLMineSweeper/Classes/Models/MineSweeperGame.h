//
//  MineSweeperGame.h
//  HLMineSweeper
//
//  Created by Hao Liu on 7/19/15.
//  Copyright (c) 2015 Hao Liu. All rights reserved.
//

typedef NS_ENUM(NSInteger, GameState)
{
    GameState_Ready,
    GameState_Playing,
    GameState_Win,
    GameState_Lose,
};

typedef NS_ENUM(NSInteger, Hardness)
{
    Hardness_Easy,
    Hardness_Intermediate,
    Hardness_Expert,
};

@protocol MineSweeperGameDelegate

- (void) flagsExhausted;

@end

@interface MineSweeperGame : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *tiles;
@property (nonatomic, assign, readonly) GameState gameState;
@property (nonatomic, assign, readonly) NSInteger rows;
@property (nonatomic, assign, readonly) NSInteger columns;
@property (nonatomic, assign, readonly) NSInteger remainFlags;
@property (nonatomic, weak, readwrite) id<MineSweeperGameDelegate> delegate;

// Single quick tap
- (void) stepOnRow: (NSInteger) row atColumn: (NSInteger) column;

// Flag, Unflag (long tap)
- (void) toggleTileAtRow: (NSInteger) row atColumn: (NSInteger) column;
- (BOOL) checkGameFinished;
- (void) reset;

+ (instancetype) createMineSweeperGameInEasyMode;
+ (instancetype) createMineSweeperGameInIntermediateMode;
+ (instancetype) createMineSweeperGameInHardMode;

@end
