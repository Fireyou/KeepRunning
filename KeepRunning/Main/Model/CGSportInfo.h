//
//  CGSportInfo.h
//  跑跑
//
//  Created by CHENGuo on 21/08/2015.
//  Copyright (c) 2015 CHENGuo. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface CGSportInfo : NSObject <NSCoding>

/** 总共运动用时 */
@property (nonatomic, copy) NSString *totalTimeUsed;

/** 总共运动距离 */
@property (nonatomic, assign) int totalRunKilometers;

/** 总共消耗卡路里 */
@property (nonatomic, assign) int totalEnergie;

//需要储存的东西
/** 每次消耗的卡路里 */
@property (nonatomic, strong) NSNumber *energie;

/** 每次运动距离 */
@property (nonatomic, strong)  NSNumber *runKilometers;

/** 每次平均速度 */
@property (nonatomic, strong) NSNumber *averageSpeed;

/** 运动的日期 */
@property (nonatomic, strong) NSDateComponents *sportDate;

/** 每次的跑步路线 */
@property (nonatomic, strong) NSMutableArray *runLine;

@property (nonatomic, strong) NSNumber *saveID;

@end
