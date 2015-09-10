//
//  CGSongsPlayerController.m
//  跑跑
//
//  Created by CHENGuo on 15/9/3.
//  Copyright (c) 2015年 CHENGuo. All rights reserved.
//

#import "CGSongsPlayerController.h"
#import "UIImage+Image.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UINavigationBar+Awesome.h"
#import "CGMusicPlayerBar.h"
#import "CGMusicPlayerCell.h"
#import "CGHeader.h"
#import "Masonry.h"

#define NAVBAR_CHANGE_POINT 50
@interface CGSongsPlayerController ()<UITableViewDataSource,UITableViewDelegate,CGMusicPlayerBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UIView *albumView;
@property (nonatomic, strong) NSIndexPath *selectedCellPath;
@property (nonatomic, strong) MPMediaItemCollection *itemCollection;

@end

@implementation CGSongsPlayerController
//在初始化时添加监听
- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellDidSelect:) name:CGAlbumDidSelectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingItemDidChange) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];
    
   
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //导航栏设置
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.title = self.itemCollection.representativeItem.albumTitle;
    self.tableView.dataSource = self;
    if (self.itemCollection.representativeItem.artwork) {
        UIImage *image = [self.itemCollection.representativeItem.artwork imageWithSize:CGSizeMake(300, 300)];
        
        self.albumImageView.image = image;
    }else{
        self.albumImageView.image = [UIImage imageNamed:@"GTA5 PNG (2)"];
    }
   
    self.albumImageView.contentMode = UIViewContentModeScaleAspectFill;

    
    self.navigationItem.title = [MPMusicPlayerController systemMusicPlayer].nowPlayingItem.title;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}
//在这里post通知，晚于CGMusicPlayerBar的initWithFrame
- (void)viewDidAppear:(BOOL)animated
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[CGChangeAlbumKey] = self.itemCollection;
    [[NSNotificationCenter defaultCenter] postNotificationName:CGAlbumDidChangeNotification object:nil userInfo:userInfo];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
    
}

#pragma mark - 通知
-(void)nowPlayingItemDidChange
{
    self.navigationItem.title = [MPMusicPlayerController systemMusicPlayer].nowPlayingItem.title;
}
- (void)cellDidSelect:(NSNotification *)notification
{
    self.itemCollection = notification.userInfo[CGSelectAlbumKey];
        
}
//删除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    CGMusicPlayerBar *headerView = [[CGMusicPlayerBar alloc] init];
//    headerView.delegate = self;
//    headerView.frame = CGRectMake(0, 0, tableView.bounds.size.width, 90);
//    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.width.equalTo(headerView.superview.mas_width);
//        make.height.equalTo(headerView.superview.mas_height);
//    }];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 90;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.itemCollection.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.创建cell
    CGMusicPlayerCell *cell = [CGMusicPlayerCell cellWithTableView:tableView];
    
    // 2.设置cell的数据
    MPMediaItem *item = self.itemCollection.items[indexPath.row];
    
    cell.songName = item.title;
    
//    cell.leftBtnImage = nil;
    cell.number = (int)indexPath.row;
//    被选中cell显示不同图片
//    if (indexPath == self.selectedCellPath) {
//        if ([MPMusicPlayerController systemMusicPlayer].playbackState == MPMusicPlaybackStatePlaying) {
//            cell.leftBtnImage = @"hp_player_btn_pause_normal";
//        }else{
//            cell.leftBtnImage = @"hp_player_btn_play_normal";
//        }
//        
//    }else{
//        
//        
//        cell.number = (int)indexPath.row;
//
//        
//    }
//    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[CGSelectSongIndexPathKey] = indexPath;
    [[NSNotificationCenter defaultCenter] postNotificationName:CGSongDidSelectNotification object:self userInfo:userInfo];
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
//    
//    CGFloat alpha = 0;
//    // 获取当前偏移量
//    CGFloat offsetY = -scrollView.contentOffset.y;
//    
//    // 获取偏移量差值
//    CGFloat delta = offsetY;
//    
//    // 计算透明度
//    alpha = 1 - delta / ([UIScreen mainScreen].bounds.size.width);
//    
//    // 设置导航条背景图片
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:alpha]] forBarMetrics:UIBarMetricsDefault];
//    
    UIColor * color = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
#pragma mark - CGMusicPlayerBarDelegate

@end
