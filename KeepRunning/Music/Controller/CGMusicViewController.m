//
//  CGMusicViewController.m
//  KeepRunning
//
//  Created by CHENGuo on 15/9/10.
//  Copyright © 2015年 CHENGuo. All rights reserved.
//

#import "CGMusicViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CGAlbumCell.h"
#import "CGSongsPlayerController.h"
#import "CGHeader.h"

@interface CGMusicViewController ()


@property (nonatomic, strong) MPMediaQuery *mediaQueue;
@property (nonatomic, strong) CGSongsPlayerController *songsPlayerController;
@property (nonatomic, strong) MPMediaItemCollection *itemColletion;



@end

@implementation CGMusicViewController

//- (CGSongsPlayerController *)songsPlayerController
//{
//    if (!_songsPlayerController) {
//        UIStoryboard *songsPlayerSB = [UIStoryboard storyboardWithName:@"CGSongsPlayerController" bundle:nil];
//        self.songsPlayerController = songsPlayerSB.instantiateInitialViewController;
//    }
//
//    return _songsPlayerController;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mediaQueue.groupingType = MPMediaGroupingAlbumArtist;
    self.mediaQueue = [MPMediaQuery albumsQuery];
    self.itemColletion = self.mediaQueue.collections[0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(pushViewController)];
}

- (void)pushViewController
{
    UIStoryboard *songsPlayerSB = [UIStoryboard storyboardWithName:@"CGSongsPlayerController" bundle:nil];
    [self.navigationController pushViewController:songsPlayerSB.instantiateInitialViewController animated:YES];
    
    //传递collection模型
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[CGSelectAlbumKey] = self.itemColletion;
    [[NSNotificationCenter defaultCenter] postNotificationName:CGAlbumDidSelectNotification object:nil userInfo:userInfo];
    
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  self.mediaQueue.collections.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.创建cell
    CGAlbumCell *cell = [CGAlbumCell cellWithTableView:tableView];
    
    // 2.设置cell的数据
    
    MPMediaItemCollection *collection = self.mediaQueue.collections[indexPath.row];
    MPMediaItem *item = collection.representativeItem;
    
    
    cell.songsCount = (int)collection.items.count;
    cell.singerName = item.artist;
    cell.albumName = item.albumTitle;
    
    if (item.artwork) {
        cell.albumImage = [item.artwork imageWithSize:CGSizeMake(30, 30)];
    }else{
        cell.albumImage = [UIImage imageNamed:@"placeHolder"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
    
    UIStoryboard *songsPlayerSB = [UIStoryboard storyboardWithName:@"CGSongsPlayerController" bundle:nil];
    
    [self.navigationController pushViewController:songsPlayerSB.instantiateInitialViewController animated:YES];
    
    
    //传递collection模型
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[CGSelectAlbumKey] = self.mediaQueue.collections[indexPath.row];
    self.itemColletion = self.mediaQueue.collections[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:CGAlbumDidSelectNotification object:nil userInfo:userInfo];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
