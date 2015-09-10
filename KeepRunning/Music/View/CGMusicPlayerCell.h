//
//  CGMusicPlayerCell.h
//  跑跑
//
//  Created by CHENGuo on 15/9/3.
//  Copyright (c) 2015年 CHENGuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGMusicPlayerCell : UITableViewCell
@property (nonatomic, copy) NSString *leftBtnImage;
@property (nonatomic, copy) NSString *songName;
@property (nonatomic, assign) int number;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
