//
//  MineSweeperGame.m
//  HLMineSweeper
//
//  Created by Hao Liu on 7/19/15.
//  Copyright (c) 2015 Hao Liu. All rights reserved.
//

static const NSInteger kBoardSizeInEasyMode = 8;
static const NSInteger kMinesCountInEasyMode = 10;
static const NSInteger kBoardSizeInIntermediateMode = 12;
static const NSInteger kMinesCountInIntermediateMode = 20;
static const NSInteger kBoardSizeInHardMode = 16;
static const NSInteger kMinesCountInHardMode = 40;

#import "MineSweeperGame.h"
#import "Tile.h"

@interface MineSweeperGame()

@property (nonatomic, strong, readwrite) NSMutableArray *tiles;
@property (nonatomic, assign, readwrite) NSInteger rows;
@property (nonatomic, assign, readwrite) NSInteger columns;
@property (nonatomic, assign, readwrite) NSInteger mines;
@property (nonatomic, assign, readwrite) GameState gameState;
@property (nonatomic, assign, readwrite) NSInteger revealedCount;
@property (nonatomic, assign, readwrite) NSInteger remainFlags;

@end

@implementation MineSweeperGame

- (instancetype) initWithRows:(NSInteger) rows
                  withColumns: (NSInteger) columns
                    withMines: (NSInteger) mines
{
    if (self = [super init])
    {
        self.rows = rows;
        self.columns = columns;
        self.mines = mines;
        self.tiles = [NSMutableArray arrayWithCapacity: self.rows * self.columns];
        self.revealedCount = 0;
        self.remainFlags = self.mines;
        [self initTiles];
    }
    
    return self;
}

- (void) initTiles
{
    for (NSInteger i = 0; i < self.rows; ++i)
    {
        for (NSInteger j = 0; j < self.columns; ++j)
        {
            Tile *tile = [[Tile alloc] init];
            [self.tiles addObject: tile];
        }
    }
}

- (BOOL) checkGameFinished
{
    return self.gameState == GameState_Win || self.gameState == GameState_Lose;
}

- (Tile *) getTileAtRow: (NSInteger) row atColumn: (NSInteger) column
{
    return [self.tiles objectAtIndex: row * self.columns + column];
}

- (void) generateMinesExcludeTileAtRow: (NSInteger) excludedRow
                              atColumn: (NSInteger) excludedColumn
{
    NSInteger remainingMines = self.mines;
    NSInteger totalTiles = self.rows * self.columns;
    NSInteger randomNumber;
    
    NSInteger curRow = 0;
    NSInteger curCol = 0;
    
    srand(time(NULL));
    while (remainingMines > 0)
    {
        randomNumber = rand() % totalTiles;
        
        if (randomNumber < 1)
        {
            Tile *tile = [self getTileAtRow: curRow atColumn: curCol];
            
            if (!tile.isMine && curRow != excludedRow && curCol != excludedColumn)
            {
                [self placeMineAtRow: curRow atColumn: curCol];
                --remainingMines;
            }
        }
        
        ++curCol;
        if (curCol >= self.columns)
        {
            curCol = 0;
            ++curRow;
        }
        if (curRow >= self.rows)
        {
            curRow = 0;
        }
    }
}

- (void) placeMineAtRow: (NSInteger) row atColumn: (NSInteger) column
{
    Tile *tile = [self getTileAtRow: row atColumn: column];
    tile.isMine = YES;
    
    // Update adjacent tiles' number
    for (NSInteger rowDiff = -1; rowDiff <= 1; ++rowDiff)
    {
        for (NSInteger colDiff = -1; colDiff <= 1; ++colDiff)
        {
            NSInteger adjRow = row + rowDiff;
            NSInteger adjCol = column + colDiff;
            
            if (adjRow < 0 ||
                adjRow >= self.rows ||
                adjCol < 0 ||
                adjCol >= self.columns ||
                (rowDiff == 0 && colDiff == 0))
            {
                continue;
            }
            else
            {
                Tile *adjacentTile = [self getTileAtRow: adjRow atColumn: adjCol];
                ++adjacentTile.number;
            }
        }
    }
}

- (void) toggleTileAtRow: (NSInteger) row atColumn: (NSInteger) column
{
    Tile *tile = [self getTileAtRow: row atColumn: column];
    if (tile.tileState == TileState_Covered)
    {
        if (self.remainFlags == 0)
        {
            [self.delegate flagsExhausted];
        }
        else
        {
            tile.tileState = TileState_Flagged;
            --self.remainFlags;
        }
    }
    else if (tile.tileState == TileState_Flagged)
    {
        tile.tileState = TileState_Covered;
        ++self.remainFlags;
    }
}

- (void) stepOnRow: (NSInteger) row atColumn: (NSInteger) column
{
    // If game is completed, then do nothing
    if (self.gameState == GameState_Lose || self.gameState == GameState_Win)
    {
        return;
    }
    
    // 1st time revealing a tile which should not be a mine
    // So that we need to generate mines after 1st time tapping
    if (self.gameState == GameState_Ready)
    {
        self.gameState = GameState_Playing;
        [self generateMinesExcludeTileAtRow: row atColumn: column];
    }
    
    Tile *tile = [self getTileAtRow: row atColumn: column];

    if (tile.isMine)
    {
        self.gameState = GameState_Lose;
    }
    else
    {
        [self exploreFromRow: row atColumn: column];
        
        if (self.revealedCount == self.rows * self.columns - self.mines)
        {
            self.gameState = GameState_Win;
        }
    }
}

- (void) exploreFromRow: (NSInteger) row atColumn: (NSInteger) column
{
    // Out of scope
    if (row < 0 || row >= self.rows || column < 0 || column >= self.columns)
    {
        return;
    }
    
    Tile *tile = [self getTileAtRow: row atColumn: column];
    
    // Skip mine or revealed or flagged tiles
    if (tile.isMine ||
        tile.tileState == TileState_Revealed ||
        tile.tileState == TileState_Flagged)
    {
        return;
    }
    
    if (tile.tileState == TileState_Covered)
    {
        tile.tileState = TileState_Revealed;
        ++self.revealedCount;
        // Tile with number is the farthest grid we could reach
        if (tile.number > 0)
        {
            return;
        }
    }
    
    [self exploreFromRow: row + 1 atColumn: column];
    [self exploreFromRow: row - 1 atColumn: column];
    [self exploreFromRow: row atColumn: column - 1];
    [self exploreFromRow: row atColumn: column + 1];
}

- (void) reset
{
    [self.tiles removeAllObjects];
    [self initTiles];
    self.gameState = GameState_Ready;
    self.revealedCount = 0;
    self.remainFlags = self.mines;
}

+ (instancetype) createMineSweeperGameInEasyMode
{
    return [[MineSweeperGame alloc] initWithRows: kBoardSizeInEasyMode
                                     withColumns: kBoardSizeInEasyMode
                                       withMines: kMinesCountInEasyMode];
}

+ (instancetype) createMineSweeperGameInIntermediateMode
{
    return [[MineSweeperGame alloc] initWithRows: kBoardSizeInIntermediateMode
                                     withColumns: kBoardSizeInIntermediateMode
                                       withMines: kMinesCountInIntermediateMode];
}

+ (instancetype) createMineSweeperGameInHardMode
{
    return [[MineSweeperGame alloc] initWithRows: kBoardSizeInHardMode
                                     withColumns: kBoardSizeInHardMode
                                       withMines: kMinesCountInHardMode];
}

@end
