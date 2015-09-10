//
//  CGRunningViewController.m
//  跑跑
//
//  Created by CHENGuo on 20/08/2015.
//  Copyright (c) 2015 CHENGuo. All rights reserved.
//

#import "CGRunningViewController.h"

#import "MZTimerLabel.h"
#import "CGSportInfo.h"
#import "CGBetterMapView.h"
#import "CGReadrawMapViewController.h"
#import "CGSportInfoSaveTool.h"
#import "CGHeader.h"
#import "FMDB.h"

//static FMDatabase *_db;
@interface CGRunningViewController ()<CGBetterMapViewDelegate,MZTimerLabelDelegate>
- (IBAction)pasueOrResume;
- (IBAction)stop;

@property (weak, nonatomic) IBOutlet MZTimerLabel *runTimeLabel;
@property (weak, nonatomic) IBOutlet CGBetterMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *energieLabel;
@property (weak, nonatomic) IBOutlet UILabel *altitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *runDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;

@property (nonatomic, assign) float runDistance;
@property (nonatomic, assign) float preTime;
@property (nonatomic, assign) float energie;
@property (nonatomic, assign) float averagSpeed;
@property (nonatomic, assign) BOOL isTimePasused;
@property (nonatomic, strong) NSMutableArray *locations;


@property (nonatomic, strong) NSMutableArray *sportInfos;
@end

@implementation CGRunningViewController

- (NSMutableArray *)locations
{
    if (!_locations) {
        self.locations = [[NSMutableArray alloc] init];
    }
    return _locations;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self.runTimeLabel start];
    self.runTimeLabel.delegate = self;
    
    self.stopBtn.layer.cornerRadius = 5;
    self.pauseBtn.layer.cornerRadius = 5;
    self.runDistance = 0;
    self.preTime = 0;
    self.energie = 0;
    
    //添加button
    
    MKUserTrackingBarButtonItem *userTrackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView.map];
    
    
    self.navigationItem.rightBarButtonItems = @[userTrackingButton];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

    [self.mapView.map setUserTrackingMode:[settings integerForKey:UserTrackingModePrefsKey] animated:YES];
    
}


- (void)pushVc
{
    CGReadrawMapViewController *vc = [[CGReadrawMapViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (IBAction)pasueOrResume {
    self.isTimePasused = !self.isTimePasused;
    if (self.isTimePasused) {
        [self.runTimeLabel pause];
        [self.pauseBtn setTitle:@"恢复" forState:(UIControlStateNormal)];
        [self.pauseBtn setBackgroundColor:[UIColor cyanColor]];
        
    }else{
        [self.runTimeLabel start];
        [self.pauseBtn setTitle:@"暂停" forState:(UIControlStateNormal)];
        [self.pauseBtn setBackgroundColor:[UIColor lightGrayColor]];
        
    }
    
}

- (IBAction)stop {
    
    
    CGSportInfo *sportInfo = [[CGSportInfo alloc] init];
    
    //平均速度
    sportInfo.averageSpeed = [NSNumber numberWithFloat:self.averagSpeed];


    //消耗的能量
    sportInfo.energie = [NSNumber numberWithFloat:self.energie];
    
    //运动公里数
    sportInfo.runKilometers = [NSNumber numberWithFloat:self.runDistance];
    
    
    //添加当前时间
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitHour| NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitMinute;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    sportInfo.sportDate = dateComponent;
    
    //取一个年月出来单独做储存ID
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    
    //把ID存为201508这种格式
    sportInfo.saveID = [NSNumber numberWithInt:[NSString stringWithFormat:@"%ld%02ld",(long)year,(long)month].intValue];
    
    
    
    //添加跑步路线
    sportInfo.runLine = self.locations;
    //归档数组
    [CGSportInfoSaveTool addsportInfo:sportInfo];
    

    
    
    
   
}
#pragma mark - CGMapViewDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateNewLocation:(CLLocation *)userLocation
{
    [self.locations addObject:userLocation];
    //速度设置
    self.speedLabel.text = [NSString stringWithFormat:@"%.2f Km/h",userLocation.speed * 3.6];
    
    //计算公里数
    CGFloat runtime =  (self.runTimeLabel.getTimeCounted - self.preTime) / 3600;
    CGFloat speed = userLocation.speed * 3.6;
    self.preTime = self.runTimeLabel.getTimeCounted;
    
    

    
    self.runDistance +=  runtime * speed;
    self.averagSpeed = self.runDistance / (self.runTimeLabel.getTimeCounted / 3600);
    
    self.runDistanceLabel.text = [NSString stringWithFormat:@"%.2f Km",self.runDistance];


    //海拔设置
    self.altitudeLabel.text = [NSString stringWithFormat:@"%.2f m", userLocation.altitude];
    
    //卡路里消耗
    self.energie += speed * runtime * speed;
    self.energieLabel.text = [NSString stringWithFormat:@"%.1f Kcal", self.energie];
    
}
#pragma mark - MZTimerLabelDelegate
- (NSString*)timerLabel:(MZTimerLabel *)timerLabel customTextToDisplayAtTime:(NSTimeInterval)time
{
    if([timerLabel isEqual:self.runTimeLabel]){
        int second = (int)time  % 60;
        int minute = ((int)time / 60) % 60;
        int hours = time / 3600;
        return [NSString stringWithFormat:@"%02dh %02dm %02ds",hours,minute,second];
        
    }
    else
        return nil;
}
@end
