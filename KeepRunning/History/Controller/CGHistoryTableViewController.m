//
//  CGHistoryTableViewController.m
//  KeepRunning
//
//  Created by CHENGuo on 15/9/10.
//  Copyright © 2015年 CHENGuo. All rights reserved.


#import "CGHistoryTableViewController.h"
#import "CGSportInfo.h"
#import "CGReadrawMapViewController.h"
#import "FMDB.h"
#import "CGSportInfoSaveTool.h"


@interface CGHistoryTableViewController ()
@property (nonatomic, strong) NSMutableArray *sportInfos;
@end

@implementation CGHistoryTableViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sportInfos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSMutableArray *array = self.sportInfos[section];
    
    return array.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSMutableArray *array = self.sportInfos[section];
    CGSportInfo *sportInfo = [array lastObject];
    
    
    return [NSString stringWithFormat:@"%ld",(long)sportInfo.saveID.integerValue];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.创建cell
    static NSString *ID = @"contact";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    // 2.设置cell的数据
    CGSportInfo *sportInfo = self.sportInfos[indexPath.section][indexPath.row];
    NSDateComponents *dateComponent = sportInfo.sportDate;
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    NSInteger day = [dateComponent day];
    NSInteger hour = [dateComponent hour];
    NSInteger minute = [dateComponent minute];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld/%02ld/%ld/%ld/%ld",(long)year,(long)month,(long)day,(long)hour,(long)minute];
    
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%f",[sportInfo.energie floatValue]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}
//每次进入window获取最新的数据模型
- (void)viewDidAppear:(BOOL)animated
{
    self.sportInfos = [CGSportInfoSaveTool sportInfos];
    [self.tableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGReadrawMapViewController *vc = [[CGReadrawMapViewController alloc] init];
    CGSportInfo *sportInfo = self.sportInfos[indexPath.section][indexPath.row];
    
    vc.locations = sportInfo.runLine;
    
    [self.navigationController pushViewController:vc animated:YES];
}



@end
