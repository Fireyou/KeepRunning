//
//  CGSportInfoSaveTool.h
//  跑跑
//
//  Created by CHENGuo on 15/9/9.
//  Copyright (c) 2015年 CHENGuo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CGSportInfo;

@interface CGSportInfoSaveTool : NSObject
+ (NSMutableArray *)sportInfos;
+ (void)addsportInfo:(CGSportInfo *)sportInfo;
@end
