//
//  CGHeader.h
//  KeepRunning
//
//  Created by CHENGuo on 15/9/10.
//  Copyright © 2015年 CHENGuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGHeader : NSObject
/**
 *  选择歌曲通知
 */
extern NSString * const CGSongDidSelectNotification;
/**
 *  选择专辑通知
 */
extern NSString * const CGAlbumDidSelectNotification;
/**
 *  需要重新加载一个itemCollection时候用
 */
extern NSString * const CGAlbumDidChangeNotification;
/**
 *  传递歌曲 Indexpath
 */
extern NSString * const CGSelectSongIndexPathKey;
/**
 *  传递一张专辑
 */
extern NSString * const CGSelectAlbumKey;
/**
 *  需要换的专辑
 */
extern NSString * const CGChangeAlbumKey;


/**
 *  随机色
 */
#define CGRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1]
/**
 *  RGB色
 */
#define CGRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]


// value is a BOOL
extern NSString * const TrackLocationInBackgroundPrefsKey;

// value is a CLLocationAccuracy (double)
extern NSString * const LocationTrackingAccuracyPrefsKey;

// value is a BOOL
extern NSString * const PlaySoundOnLocationUpdatePrefsKey;
// 地图跟随状态
extern NSString * const UserTrackingModePrefsKey;

@end
