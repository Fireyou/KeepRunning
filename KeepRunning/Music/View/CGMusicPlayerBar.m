//
//  CGMusicPlayerBar.m
//  跑跑
//
//  Created by CHENGuo on 15/9/3.
//  Copyright (c) 2015年 CHENGuo. All rights reserved.
//

#import "CGMusicPlayerBar.h"
#import "UIView+Extension.h"
#import "CGHeader.h"
#import "MBProgressHUD+MJ.h"
#import "Masonry.h"

@interface CGMusicPlayerBar()
@property (nonatomic, weak) UIButton *playBtn;
@property (nonatomic, weak) UIButton *nextBtn;
@property (nonatomic, weak) UIButton *prevBtn;
@property (nonatomic, weak) UIButton *playModeBtn;
@property (nonatomic, weak) UIButton *repeatBtn;
@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;
@property (nonatomic, strong) MPMediaItemCollection *itemCollection;
@property (nonatomic, assign) int repeatBtnCount;
/** 判断点击的cell是否一样*/
@property (nonatomic, strong) NSIndexPath *lastIndexPath;
@end
@implementation CGMusicPlayerBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackState) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNowPlayingItem:) name:CGSongDidSelectNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadItemCollection:) name:CGAlbumDidChangeNotification object:nil];
        
        self.playBtn = [self addBtnWithImage:@"player_btn_play_normal" highImage:@"hp_player_btn_play_highlight"];
        self.nextBtn = [self addBtnWithImage:@"player_btn_next_normal" highImage:@"player_btn_next_highlight"];
        self.prevBtn = [self addBtnWithImage:@"player_btn_pre_normal" highImage:@"player_btn_pre_highlight"];
        self.repeatBtn = [self addBtnWithImage:@"ICon_Random2" highImage:nil];
        
        [self.playBtn addTarget:self action:@selector(playBtnClicked) forControlEvents:(UIControlEventTouchUpInside)];
        [self.nextBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:(UIControlEventTouchUpInside)];
        [self.prevBtn addTarget:self action:@selector(prevBtnClicked) forControlEvents:(UIControlEventTouchUpInside)];
        [self.repeatBtn addTarget:self action:@selector(repeatBtnClicked) forControlEvents:(UIControlEventTouchUpInside)];
        
        self.backgroundColor = CGRGBColor(29, 56, 72);
        self.musicPlayer.repeatMode = MPMusicRepeatModeAll;
        [self playbackState];
        
    }
    return self;
}

- (UIButton *)addBtnWithImage:(NSString *)image highImage:(NSString *)highImage
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    if (highImage) {
        [btn setImage:[UIImage imageNamed:highImage] forState:(UIControlStateHighlighted)];
    }
    
    [self addSubview:btn];
    
    return btn;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
 
    
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.center.equalTo(self);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(90);
    }];
    
    [self.prevBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(90);
        make.right.equalTo(self.playBtn.mas_left);
        make.top.equalTo(self.mas_top);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.centerX.equalTo(self.playBtn.mas_centerX).offset(90);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(34);
        make.height.mas_equalTo(30);
        make.right.equalTo(self.prevBtn.mas_left);
    }];
    
    
}
#pragma mark - 点击方法
- (void)repeatBtnClicked
{
    self.repeatBtnCount ++;
    switch (self.repeatBtnCount) {
        case 1:
            //重复一首
            [self.repeatBtn setImage:[UIImage imageNamed:@"ICon_Random3"] forState:(UIControlStateNormal)];
            self.musicPlayer.repeatMode = MPMusicRepeatModeOne;
            [MBProgressHUD show:@"单曲循环" icon:nil view:nil];

            break;
        case 2:
            //随机
            [self.repeatBtn setImage:[UIImage imageNamed:@"ICon_Random"] forState:(UIControlStateNormal)];
            self.musicPlayer.shuffleMode = MPMusicShuffleModeSongs;
            self.musicPlayer.repeatMode = MPMusicRepeatModeNone;
            [MBProgressHUD show:@"随机播放" icon:nil view:nil];
            break;
        case 3:
            
            
            //重复所有
            [self.repeatBtn setImage:[UIImage imageNamed:@"ICon_Random2"] forState:(UIControlStateNormal)];
            self.musicPlayer.repeatMode = MPMusicRepeatModeAll;
            self.musicPlayer.shuffleMode = MPMusicShuffleModeOff;
            [MBProgressHUD show:@"循环播放" icon:nil view:nil];
            break;

        
    }
 
    
    if (self.repeatBtnCount > 2) {
        self.repeatBtnCount = 0;
    }
    
    
}
- (void)playBtnClicked
{
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        [self.musicPlayer pause];
    }else{
        [self.musicPlayer play];
    }
}
- (void)prevBtnClicked
{
    [self.musicPlayer pause];
    [self.musicPlayer skipToPreviousItem];
    [self.musicPlayer play];
}
- (void)nextBtnClicked
{
    [self.musicPlayer pause];
    [self.musicPlayer skipToNextItem];
    [self.musicPlayer play];
}

#pragma mark - 通知方法
- (void)loadItemCollection:(NSNotification *)notification
{
    self.itemCollection = notification.userInfo[CGChangeAlbumKey];
    
    [self.musicPlayer setQueueWithItemCollection:self.itemCollection];

    
}
- (void)changeNowPlayingItem:(NSNotification *)notification
{

    NSIndexPath *indexPath = notification.userInfo[CGSelectSongIndexPathKey];
    //点击同一首歌，就切换播放状态
    if (self.lastIndexPath == indexPath) {
        if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
            [self.musicPlayer pause];
            
        }else{
            [self.musicPlayer play];
        }
        //  点击不同歌曲，就切换歌曲
    }else{
        self.musicPlayer.nowPlayingItem = self.itemCollection.items[indexPath.row];
        [self.musicPlayer play];
    }
    
    self.lastIndexPath = indexPath;

    
//    NSLog(@"%lu %ld", (unsigned long)self.musicPlayer.indexOfNowPlayingItem, (long)indexPath.row);
    
}
- (void)playbackState
{
        if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        
        [self.playBtn setImage:[UIImage imageNamed:@"player_btn_pause_normal"] forState:(UIControlStateNormal)];
        [self.playBtn setImage:[UIImage imageNamed:@"hp_player_btn_pause_highlight"] forState:(UIControlStateHighlighted)];
    }else{
        [self.playBtn setImage:[UIImage imageNamed:@"player_btn_play_normal"] forState:(UIControlStateNormal)];
        [self.playBtn setImage:[UIImage imageNamed:@"hp_player_btn_play_highlight"] forState:(UIControlStateHighlighted)];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - musicPlayer
-(MPMusicPlayerController *)musicPlayer
{
    if (!_musicPlayer) {
        _musicPlayer = [MPMusicPlayerController systemMusicPlayer];
        //开启通知，否则监控不到MPMusicPlayerController的通知
        [_musicPlayer beginGeneratingPlaybackNotifications];
        
    }
    return _musicPlayer;
}


@end
