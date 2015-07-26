//
//  GameViewController.m
//  HLMineSweeper
//
//  Created by Hao Liu on 7/19/15.
//  Copyright (c) 2015 Hao Liu. All rights reserved.
//

#import "GameViewController.h"
#import "MineSweeperGame.h"
#import "GameManager.h"
#import "Tile.h"
#import "UIButton+TileButton.h"
#import "UIImage+Tint.h"

static const CGFloat kTopBarHeight = 60;

@interface GameViewController()

@property (nonatomic, strong, readwrite) NSMutableArray *tileButtons;
@property (nonatomic, strong, readwrite) UIView *topBar;
@property (nonatomic, strong, readwrite) UIButton *modeButton;
@property (nonatomic, strong, readwrite) UIButton *cheatButton;
@property (nonatomic, strong, readwrite) UILabel *flagRemainingLabel;
@property (nonatomic, strong, readwrite) UILabel *timeLapseLabel;
@property (nonatomic, strong, readwrite) UIButton *faceButton;
@property (nonatomic, strong, readwrite) MineSweeperGame *game;
@property (nonatomic, strong, readwrite) NSTimer *secCountingTimer;
@property (nonatomic, strong, readwrite) NSDate *gameStartTime;

@end

@implementation GameViewController

#pragma mark -- getter for views -- 

- (UIView *) topBar
{
    if (_topBar == nil)
    {
        _topBar = [[UIView alloc] initWithFrame: CGRectZero];
        _topBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent: 0.8];
        
        [_topBar addSubview: self.modeButton];
        [_topBar addSubview: self.cheatButton];
        [_topBar addSubview: self.faceButton];
        [_topBar addSubview: self.flagRemainingLabel];
        [_topBar addSubview: self.timeLapseLabel];
        
        [self.view addSubview: _topBar];
    }
    return _topBar;
}

- (UIButton *) modeButton
{
    if (_modeButton == nil)
    {
        _modeButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_modeButton setTitle: NSLocalizedString(@"Mode", @"") forState: UIControlStateNormal];
        [_modeButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
        [_modeButton sizeToFit];
        
        [_modeButton addTarget:self action:@selector(modeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modeButton;
}

- (UIButton *) cheatButton
{
    if (_cheatButton == nil)
    {
        _cheatButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_cheatButton setTitle: NSLocalizedString(@"Cheat", @"") forState: UIControlStateNormal];
        [_cheatButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
        [_cheatButton sizeToFit];
        [_cheatButton addTarget:self action:@selector(cheatButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cheatButton;
}

- (UIButton *) faceButton
{
    if (_faceButton == nil)
    {
        _faceButton = [UIButton buttonWithType: UIButtonTypeCustom];
        _faceButton.frame = CGRectMake(0, 0, 40, 40);
        [_faceButton setBackgroundImageForAllStates: [UIImage imageNamed: @"face_smily.png"]];
        [_faceButton addTarget:self action:@selector(faceButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceButton;
}

- (UILabel *) flagRemainingLabel
{
    if (_flagRemainingLabel == nil)
    {
        _flagRemainingLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 60, 40)];
        _flagRemainingLabel.backgroundColor = [UIColor grayColor];
        _flagRemainingLabel.textColor = [UIColor redColor];
        _flagRemainingLabel.textAlignment = NSTextAlignmentRight;
        _flagRemainingLabel.text = [NSString stringWithFormat:@"%ld", self.game.remainFlags];
    }
    return _flagRemainingLabel;
}

- (UILabel *) timeLapseLabel
{
    if (_timeLapseLabel == nil)
    {
        _timeLapseLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 60, 40)];
        _timeLapseLabel.backgroundColor = [UIColor grayColor];
        _timeLapseLabel.textColor = [UIColor greenColor];
        _timeLapseLabel.text = @"0";
    }
    return _timeLapseLabel;
}

- (MineSweeperGame *) game
{
    if (_game == nil)
    {
        _game = [GameManager sharedManager].currentGame;
        _game.delegate = self;
    }
    
    return _game;
}

- (NSMutableArray *) tileButtons
{
    if (_tileButtons == nil)
    {
        _tileButtons = [[NSMutableArray alloc] initWithCapacity: self.game.rows * self.game.columns];
        
        for (NSInteger idx = 0; idx < self.game.rows * self.game.columns; ++idx)
        {
            UIButton *tileButton = [UIButton createEmptyTileButton];
            [_tileButtons addObject: tileButton];
            [self.view addSubview: tileButton];
            [tileButton addTarget:self action:@selector(tileButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] init];
            [longPressRecognizer addTarget: self action: @selector(tileButtonlongPressed:)];
            longPressRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
            [tileButton addGestureRecognizer: longPressRecognizer];
        }
    }
    return _tileButtons;
}

#pragma mark -- selectors --
- (void) faceButtonTapped
{
    [self resetGame];
    [self switchToSmilyFace];
    [self stopTimer];
    [self resetTimer];
    [self refreshFlagsCounter];
}

- (void) modeButtonTapped
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"Game Mode", @"")
                                                                   message: NSLocalizedString(@"You can restart game with following mode.", @"")
                                                            preferredStyle: UIAlertControllerStyleActionSheet];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *easyModeAction = [UIAlertAction actionWithTitle: NSLocalizedString(@"Easy (8 x 8, 10 mines)", @"")
                                                             style: UIAlertActionStyleDefault
                                                           handler: ^(UIAlertAction * action) {
                                                               [[GameManager sharedManager] switchToEasyMode];
                                                               [weakSelf clearGame];
                                                           }];
    
    UIAlertAction *intermediateModeAction = [UIAlertAction actionWithTitle: NSLocalizedString(@"Intermediate (12 x 12, 20 mines)", @"")
                                                                     style: UIAlertActionStyleDefault
                                                                   handler: ^(UIAlertAction * action) {
                                                                       [[GameManager sharedManager] switchToIntermediateMode];
                                                                       [weakSelf clearGame];
                                                                   }];
    
    UIAlertAction *hardModeAction = [UIAlertAction actionWithTitle: NSLocalizedString(@"Hard (16 x 16, 40 mines)", @"")
                                                            style: UIAlertActionStyleDefault
                                                          handler: ^(UIAlertAction * action) {
                                                              [[GameManager sharedManager] switchToHardMode];
                                                              [weakSelf clearGame];
                                                          }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle: NSLocalizedString(@"Cancel", @"")
                                                            style: UIAlertActionStyleCancel
                                                          handler: ^(UIAlertAction * action) {
                                                              [alert dismissViewControllerAnimated: YES completion: nil];
                                                          }];
    
    [alert addAction: easyModeAction];
    [alert addAction: intermediateModeAction];
    [alert addAction: hardModeAction];
    [alert addAction: cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) cheatButtonTapped
{
    // Only do cheat mode when you are playing
    if (self.game.gameState == GameState_Playing)
    {
        [self tempRevealMines];
    }
}

- (void) tileButtonTapped:(id)sender
{
    NSUInteger index = [self.tileButtons indexOfObject: sender];
    NSInteger row = index / self.game.columns;
    NSInteger col = index % self.game.columns;
    
    if (self.game.gameState == GameState_Ready)
    {
        [self startTimer];
    }
    
    [self.game stepOnRow: row atColumn: col];
    [self refreshGameView];
    // Check game state
    switch (self.game.gameState)
    {
        case GameState_Win:
        {
            [self switchToYehFace];
            [self stopTimer];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"You Win!", @"")
                                                            message: NSLocalizedString(@"Good Job!", @"")
                                                           delegate: self
                                                  cancelButtonTitle: NSLocalizedString(@"Dismiss", @"")
                                                  otherButtonTitles: nil];
            [alert show];
            break;
        }
        case GameState_Lose:
        {
            [self switchToSadFace];
            [self stopTimer];
            break;
        }
        default:
            break;
    }
}

- (void) tileButtonlongPressed: (UIGestureRecognizer *) recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        return;
    }
    NSUInteger index = [self.tileButtons indexOfObject: recognizer.view];
    
    [self.game toggleTileAtRow: index / self.game.columns
                      atColumn: index % self.game.columns];
    [self refreshGameView];
    [self refreshFlagsCounter];
}

- (void) viewWillAppear: (BOOL)animated
{
    [super viewWillAppear: animated];
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationController.navigationBarHidden = YES;
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self layoutGameView];
    [self layoutTopBar];
}

- (void) layoutTopBar
{
    CGFloat viewWidth = self.view.frameWidth;
    self.topBar.frame = CGRectMake(0,
                                   [UIApplication sharedApplication].statusBarFrame.size.height,
                                   viewWidth,
                                   kTopBarHeight);
    
    // Left side
    self.modeButton.frame = CGRectMake(10,
                                       (kTopBarHeight - self.modeButton.frameHeight) / 2.0,
                                       self.modeButton.frameWidth,
                                       self.modeButton.frameHeight);
    
    self.cheatButton.frame = CGRectMake(self.topBar.frameWidth - self.cheatButton.frameWidth - 10,
                                        (kTopBarHeight - self.cheatButton.frameHeight) / 2.0,
                                        self.cheatButton.frameWidth,
                                        self.cheatButton.frameHeight);
    
    self.faceButton.center = CGPointMake(self.topBar.frameWidth / 2.0, self.topBar.frameHeight / 2.0);
    
    self.flagRemainingLabel.center = CGPointMake(self.faceButton.frameX - self.flagRemainingLabel.frameWidth / 2.0 - 10,
                                                 self.faceButton.center.y);
    self.timeLapseLabel.center = CGPointMake(self.faceButton.frameRight + self.timeLapseLabel.frameWidth / 2.0 + 10,
                                             self.faceButton.center.y);
}

- (void) layoutGameView
{
    CGFloat viewWidth = self.view.frameWidth;
    
    CGFloat tileWidth = viewWidth / self.game.columns;
    CGFloat tileHeight = tileWidth;
    
    CGFloat viewHeight = tileWidth * self.game.rows;
    
    CGFloat frameX = 0;
    CGFloat frameY = (self.view.frameHeight - viewHeight) * 0.5;
    for (NSInteger row = 0; row < self.game.rows; ++row)
    {
        frameX = 0;
        for (NSInteger col = 0; col < self.game.columns; ++col)
        {
            UIButton *tileButton = self.tileButtons[row * self.game.columns + col];
            tileButton.frame = CGRectMake(frameX, frameY, tileWidth, tileHeight);
            frameX += tileWidth;
        }
        frameY += tileHeight;
    }
}

#pragma mark -- Face switches --
- (void) switchToSadFace
{
    [self.faceButton setBackgroundImageForAllStates: [UIImage imageNamed: @"face_sad"]];
}

- (void) switchToYehFace
{
    [self.faceButton setBackgroundImageForAllStates: [UIImage imageNamed: @"face_yeh"]];
}

- (void) switchToSmilyFace
{
    [self.faceButton setBackgroundImageForAllStates: [UIImage imageNamed: @"face_smily"]];
}

#pragma mark -- Timer --
- (void) startTimer
{
    self.gameStartTime = [NSDate date];
    self.secCountingTimer = [NSTimer scheduledTimerWithTimeInterval: 0.1
                                                             target: self
                                                           selector: @selector(timerTick:)
                                                           userInfo: nil
                                                            repeats:YES];
}

- (void) stopTimer
{
    [self.secCountingTimer invalidate];
}

- (void) resetTimer
{
    self.timeLapseLabel.text = @"0";
}

- (void) timerTick:(NSTimer *)timer {
    self.timeLapseLabel.text = [NSString stringWithFormat: @"%ld", (long) [[NSDate date] timeIntervalSinceDate: self.gameStartTime]];;
}

#pragma mark -- Flag count --
- (void) refreshFlagsCounter
{
    self.flagRemainingLabel.text = [NSString stringWithFormat:@"%ld", self.game.remainFlags];
}

#pragma mark -- Game utils--

// Clear whole game in order for mode changing
- (void) clearGame
{
    [self stopTimer];
    _game = nil;
    for (UIView *view in self.tileButtons)
    {
        [view removeFromSuperview];
    }
    _tileButtons = nil;
    [self.view setNeedsLayout];
    [self resetTimer];
    [self refreshFlagsCounter];
}

// Game mode is not changed, only need to reset
- (void) resetGame
{
    [self.game reset];
    [self refreshGameView];
}

// Cheat
- (void) tempRevealMines
{
    for (NSInteger row = 0; row < self.game.rows; ++row)
    {
        for (NSInteger col = 0; col < self.game.columns; ++col)
        {
            NSInteger index = row * self.game.columns + col;
            Tile *tile = self.game.tiles[index];
            UIButton *tileButton = self.tileButtons[index];
            if (tile.isMine)
            {
                [tileButton setBackgroundImageForAllStates: [[UIImage imageNamed: MINE]
                                                             tintedImageUsingColor: [UIColor greenColor]]];
            }
        }
    }
}

- (void) refreshGameView
{
    for (NSInteger row = 0; row < self.game.rows; ++row)
    {
        for (NSInteger col = 0; col < self.game.columns; ++col)
        {
            NSInteger index = row * self.game.columns + col;
            Tile *tile = self.game.tiles[index];
            UIButton *tileButton = self.tileButtons[index];
            if ([self.game checkGameFinished])
            {
                [tileButton updateWithTileWhenGameFinished: tile];
            }
            else
            {
                [tileButton updateWithTileWhenGameNotFinished: tile];
            }
        }
    }
}

#pragma mark -- Delegate --
- (void) flagsExhausted
{
    // TODO: could add a label indicating flags are exhausted to warn users
}

@end
