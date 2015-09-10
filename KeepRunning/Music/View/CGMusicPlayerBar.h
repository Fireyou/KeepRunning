//
//  CGMusicPlayerBar.h
//  跑跑
//
//  Created by CHENGuo on 15/9/3.
//  Copyright (c) 2015年 CHENGuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@class CGAlbumCell;
@protocol CGMusicPlayerBarDelegate <NSObject>
@optional

- (MPMediaItemCollection *)musicPlayerDemandForItemCollection;

@end
@interface CGMusicPlayerBar : UIView
@property (nonatomic, weak) id<CGMusicPlayerBarDelegate> delegate;

@end
