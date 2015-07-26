//
//  UIButton+TileButton.m
//  HLMineSweeper
//
//  Created by Hao Liu on 7/20/15.
//  Copyright (c) 2015 Hao Liu. All rights reserved.
//

#import "UIButton+TileButton.h"
#import "Tile.h"

NSString * const COVERED = @"covered.gif";
NSString * const MINE = @"mine.png";
NSString * const MINE_SWEEPED = @"mine_sweeped.png";
NSString * const BOMB = @"bomb.png";
NSString * const FLAG = @"flag.png";

@implementation UIButton (TileButton)

- (void) updateWithTileWhenGameNotFinished: (Tile *)tile
{
    switch (tile.tileState) {
        case TileState_Covered:
            [self setBackgroundImageForAllStates: [UIImage imageNamed: COVERED]];
            break;
            
        case TileState_Flagged:
            [self setBackgroundImageForAllStates: [UIImage imageNamed: FLAG]];
            break;
            
        case TileState_Revealed:
            if (tile.isMine)
            {
                [self setBackgroundImageForAllStates: [UIImage imageNamed: BOMB]];
            }
            else
            {
                [self setBackgroundImageForAllStates: [self getImageAtTileNum: tile.number]];
            }
            break;
            
        default:
            break;
    }
}

- (void) updateWithTileWhenGameFinished: (Tile *)tile
{
    switch (tile.tileState) {
        case TileState_Covered:
            if (tile.isMine)
            {
                [self setBackgroundImageForAllStates: [UIImage imageNamed: MINE]];
            }
            else
            {
                [self setBackgroundImageForAllStates: [UIImage imageNamed: COVERED]];
            }
            break;
            
        case TileState_Flagged:
            if (tile.isMine)
            {
                [self setBackgroundImageForAllStates: [UIImage imageNamed: MINE_SWEEPED]];
            }
            else
            {
                [self setBackgroundImageForAllStates: [UIImage imageNamed: FLAG]];
            }
            break;
            
        case TileState_Revealed:
            if (tile.isMine)
            {
                [self setBackgroundImageForAllStates: [UIImage imageNamed: BOMB]];
            }
            else
            {
                [self setBackgroundImageForAllStates: [self getImageAtTileNum: tile.number]];
            }
            break;
            
        default:
            break;
    }
}

- (UIImage *) getImageAtTileNum: (NSInteger) num
{
    return [UIImage imageNamed: [NSString stringWithFormat: @"adjacent_%ld.gif", (long) num]];
}

- (void) setBackgroundImageForAllStates:(UIImage *)image
{
    [self setBackgroundImage: image forState: UIControlStateNormal];
    [self setBackgroundImage: image forState: UIControlStateSelected];
    [self setBackgroundImage: image forState: UIControlStateHighlighted];
    [self setBackgroundImage: image forState: UIControlStateDisabled];
}

+ (UIButton *) createEmptyTileButton
{
    UIButton *tileButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [tileButton setBackgroundImage: [UIImage imageNamed: COVERED] forState: UIControlStateNormal];
    [tileButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return tileButton;
}

@end
