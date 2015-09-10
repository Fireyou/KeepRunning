//
//  CGAlbumCell.m
//  跑跑
//
//  Created by CHENGuo on 15/9/2.
//  Copyright (c) 2015年 CHENGuo. All rights reserved.
//

#import "CGAlbumCell.h"
@interface CGAlbumCell()
@property (weak, nonatomic) IBOutlet UILabel *songsCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *albumNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *singerNameLabel;

@end
@implementation CGAlbumCell

//创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    
    static NSString *ID = @"albumCell";
    CGAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CGAlbumCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
   
    
    
}
- (void)setSongsCount:(int)songsCount
{
    _songsCount = songsCount;
    self.songsCountLabel.text = [NSString stringWithFormat:@"%d首",self.songsCount];
}
- (void)setAlbumImage:(UIImage *)albumImage
{
    _albumImage = albumImage;
     self.albumImageView.image = self.albumImage;
}
- (void)setAlbumName:(NSString *)albumName
{
    _albumName = albumName;
    self.albumNameLabel.text = self.albumName;

}
- (void)setSingerName:(NSString *)singerName
{
    _singerName = singerName;
    self.singerNameLabel.text = self.singerName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
