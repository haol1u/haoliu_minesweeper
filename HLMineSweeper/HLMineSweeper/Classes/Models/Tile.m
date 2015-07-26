//
//  Tile.m
//  HLMineSweeper
//
//  Created by Hao Liu on 7/19/15.
//  Copyright (c) 2015 Hao Liu. All rights reserved.
//

#import "Tile.h"

@implementation Tile

- (instancetype) init
{
    if (self = [super init])
    {
        self.tileState = TileState_Covered;
        self.number = 0;
        self.isMine = NO;
    }
    
    return self;
}

@end
