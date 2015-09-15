//
//  CGSportInfoSaveTool.m
//  跑跑
//
//  Created by CHENGuo on 15/9/9.
//  Copyright (c) 2015年 CHENGuo. All rights reserved.
//

#import "CGSportInfoSaveTool.h"
#import "FMDB.h"
#import "CGSportInfo.h"

const FMDatabase *_db;

@implementation CGSportInfoSaveTool
 + (void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"sportInfo.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_sportInfo (id integer PRIMARY KEY, runDate integer NOT NULL, sportInfo text NOT NULL);"];

}
+ (NSMutableArray *)sportInfos
{
    
    // 得到结果集
    FMResultSet *set = [_db executeQuery:@"SELECT DISTINCT runDate FROM t_sportInfo ORDER BY runDate DESC;"];
    
    // 不断往下取数据
    NSMutableArray *sportInfos = [NSMutableArray array];
    while (set.next) {
        // 获得当前所指向的数据
        CGSportInfo *sportInfo = [[CGSportInfo alloc] init];
        NSMutableArray *array = [NSMutableArray array];
        sportInfo.saveID = [NSNumber numberWithInt:[set intForColumn:@"runDate"]];
        [array addObject:sportInfo];
        
        [sportInfos addObject:array];
        
        
    }
    
    for (int i = 0; i < sportInfos.count; i++) {
        NSMutableArray *array = sportInfos[i];
        CGSportInfo *sportInfo = [[CGSportInfo alloc] init];
        sportInfo = [array lastObject];
        
        //清空
        [array removeAllObjects];
        //再次查询结果
        FMResultSet *set = [_db executeQuery:
                            [NSString stringWithFormat:@"SELECT * FROM t_sportInfo WHERE runDate = %d  ORDER BY runDate DESC ;",sportInfo.saveID.intValue]] ;
        
        while (set.next) {
            NSData *data =[set objectForColumnName:@"sportInfo"];
            sportInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            [array insertObject:sportInfo atIndex:0];
        }
        
        [sportInfos replaceObjectAtIndex:i withObject:array];
    }
    
//    sportInfos = sportInfos;
    return sportInfos;
}

+ (void)addsportInfo:(CGSportInfo *)sportInfo
{
    
    NSDate *data = (NSDate *)[NSKeyedArchiver archivedDataWithRootObject:sportInfo];
    
    [_db executeUpdateWithFormat:@"INSERT INTO t_sportInfo(runDate, sportInfo) VALUES (%ld, %@);", (long)sportInfo.saveID.integerValue, data];
}

@end
