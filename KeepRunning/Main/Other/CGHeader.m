//
//  CGHeader.m
//  KeepRunning
//
//  Created by CHENGuo on 15/9/10.
//  Copyright © 2015年 CHENGuo. All rights reserved.
//

#import "CGHeader.h"

@implementation CGHeader
NSString * const CGSongDidSelectNotification = @"CGSongDidSelectNotification";
NSString * const CGAlbumDidSelectNotification = @"CGAlbumDidSelectNotification";
NSString * const CGSelectSongIndexPathKey = @"CGSelectSongIndexPathKey";
NSString * const CGSelectAlbumKey = @"CGSelectAlbumKey";

NSString * const CGAlbumDidChangeNotification = @"CGAlbumDidChangeNotification";

NSString * const CGChangeAlbumKey = @"CGChangeAlbumKey";

NSString * const TrackLocationInBackgroundPrefsKey = @"TrackLocationInBackgroundPrefsKey";
NSString * const LocationTrackingAccuracyPrefsKey = @"LocationTrackingAccuracyPrefsKey";

NSString * const PlaySoundOnLocationUpdatePrefsKey = @"PlaySoundOnLocationUpdatePrefsKey";

NSString * const UserTrackingModePrefsKey = @"UserTrackingModePrefsKey";
@end
