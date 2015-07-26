//
//  UIButton+TileButton.h
//  HLMineSweeper
//
//  Created by Hao Liu on 7/20/15.
//  Copyright (c) 2015 Hao Liu. All rights reserved.
//

#import "Tile.h"

extern NSString * const COVERED;
extern NSString * const MINE;
extern NSString * const MINE_SWEEPED;
extern NSString * const BOMB;
extern NSString * const FLAG;

@interface UIButton (TileButton)

- (void) updateWithTileWhenGameNotFinished: (Tile *)tile;
- (void) updateWithTileWhenGameFinished: (Tile *)tile;
- (void) setBackgroundImageForAllStates:(UIImage *)image;
+ (UIButton *) createEmptyTileButton;

@end
