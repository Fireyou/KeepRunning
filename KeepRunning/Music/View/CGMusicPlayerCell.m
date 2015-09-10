//
//  CGMusicPlayerCell.m
//  跑跑
//
//  Created by CHENGuo on 15/9/3.
//  Copyright (c) 2015年 CHENGuo. All rights reserved.
//

#import "CGMusicPlayerCell.h"
@interface CGMusicPlayerCell()

@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@end
@implementation CGMusicPlayerCell

- (void)awakeFromNib {
    // Initialization code
}
//创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    
    static NSString *ID = @"CGMusicPlayerCell";
    CGMusicPlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CGMusicPlayerCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//- (void)setHighlighted:(BOOL)highlighted
//{
//    
//}
#pragma mark - 设置数据
- (void)setLeftBtnImage:(NSString *)leftBtnImage
{
    _leftBtnImage = leftBtnImage;
    if (leftBtnImage.length) {
        [self.leftBtn setImage:[UIImage imageNamed:leftBtnImage] forState:(UIControlStateNormal)];
    }
    
    
    
}
- (void)setSongName:(NSString *)songName
{
    _songName = songName;
    self.songNameLabel.text = songName;
}
- (void)setNumber:(int)number
{
    _number = number;
    
        [self.leftBtn setTitle:[NSString stringWithFormat:@"%d",number + 1] forState:(UIControlStateNormal)];

    
    
}
@end
