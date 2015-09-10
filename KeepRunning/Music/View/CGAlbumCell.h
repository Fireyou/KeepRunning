//
//  CGAlbumCell.h
//  跑跑
//
//  Created by CHENGuo on 15/9/2.
//  Copyright (c) 2015年 CHENGuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGAlbumCell : UITableViewCell
@property (nonatomic, weak) UIImage *albumImage;
@property (nonatomic, copy) NSString *albumName;
@property (nonatomic, copy) NSString *singerName;
@property (nonatomic, assign) int songsCount;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
