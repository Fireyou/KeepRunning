//
//  CGRunViewController.m
//  KeepRunning
//
//  Created by CHENGuo on 15/9/10.
//  Copyright © 2015年 CHENGuo. All rights reserved.
//

#import "CGRunViewController.h"
#import "CGSportInfoSaveTool.h"
#import "CGRunningViewController.h"
#import "CGSportInfo.h"

@interface CGRunViewController ()
- (IBAction)startRun;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalKilometersLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalEnergieLabel;

@property (weak, nonatomic) IBOutlet UILabel *maxKilometersLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxEnergieLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxTimeLabel;
@property (nonatomic, strong) CGRunningViewController *runningViewController;
@property (nonatomic, strong) NSMutableArray *sportInfos;
@property (nonatomic, strong) CGSportInfo *sportInfo;
@end

@implementation CGRunViewController
//- (CGRunningViewController *)runningViewController
//{
//    if (!_runningViewController) {
//        self.runningViewController = [[CGRunningViewController alloc] initWithNibName:@"CGRunningViewController" bundle:nil];
//        
//        self.runningViewController.title = @"跑步";
//        self.runningViewController.view.backgroundColor = [UIColor orangeColor];
//    }
//    
//    return _runningViewController;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self setupSportInfo];
    [self setupLabels];
    
    
}
- (void)setupLabels
{
    self.maxTimeLabel.text = [self stringFortimeLabel:self.sportInfo.maxTimeUsed];
    self.maxKilometersLabel.text = [NSString stringWithFormat:@"%.2f Km",self.sportInfo.maxKilometers];
    self.maxEnergieLabel.text = [NSString stringWithFormat:@"%.2f Km",self.sportInfo.maxEnergie];
    
    self.totalEnergieLabel.text = [NSString stringWithFormat:@"%.2f Kcal", self.sportInfo.totalEnergie];
    self.totalKilometersLabel.text = [NSString stringWithFormat:@"%.2f Km",self.sportInfo.totalRunKilometers];
    self.totalTimeLabel.text = [self stringFortimeLabel:self.sportInfo.totalTimeUsed];

}
- (void)setupSportInfo
{
    self.sportInfos = [CGSportInfoSaveTool sportInfos];
    self.sportInfo = [[CGSportInfo alloc] init];
    for (int i = 0; i < self.sportInfos.count; i++) {
        NSArray *sportInfoArray = self.sportInfos[i];
        
        for (CGSportInfo *sportInfo in sportInfoArray) {
            
            self.sportInfo.totalRunKilometers += sportInfo.runKilometers.floatValue;
            self.sportInfo.totalEnergie += sportInfo.energie.floatValue;
            self.sportInfo.totalTimeUsed += sportInfo.timeUsed.floatValue;
            
            
            //取出最大值
            if (sportInfo.runKilometers.floatValue > self.sportInfo.maxKilometers) {
                self.sportInfo.maxKilometers = sportInfo.runKilometers.floatValue;
            }
            if (sportInfo.energie.floatValue > self.sportInfo.maxEnergie) {
                self.sportInfo.maxEnergie = sportInfo.energie.floatValue;
            }
            if (sportInfo.timeUsed.floatValue > self.sportInfo.maxTimeUsed) {
                self.sportInfo.maxTimeUsed = sportInfo.timeUsed.floatValue;
            }
        }
    }
    

}

- (NSString *)stringFortimeLabel:(double)time
{
//    int second = (int)time  % 60;
    int minute = ((int)time / 60) % 60;
    int hours = time / 3600;
    return [NSString stringWithFormat:@"%02d小时 %02d分",hours,minute];
}

- (IBAction)startRun {
    
    CGRunningViewController *runningViewController = [[CGRunningViewController alloc] initWithNibName:@"CGRunningViewController" bundle:nil];
    [self.navigationController pushViewController:runningViewController animated: YES];
}


@end
