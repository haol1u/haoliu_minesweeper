//
//  Tile.h
//  HLMineSweeper
//
//  Created by Hao Liu on 7/19/15.
//  Copyright (c) 2015 Hao Liu. All rights reserved.
//

typedef NS_ENUM(NSInteger, TileState) {
    TileState_Covered,
    TileState_Revealed,
    TileState_Flagged,
};

@interface Tile : NSObject

@property (nonatomic, assign, readwrite) TileState tileState;
@property (nonatomic, assign, readwrite) BOOL isMine;
@property (nonatomic, assign, readwrite) NSInteger number;

- (instancetype) init;

@end
