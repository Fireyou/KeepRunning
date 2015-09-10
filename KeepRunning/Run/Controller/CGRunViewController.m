//
//  CGRunViewController.m
//  KeepRunning
//
//  Created by CHENGuo on 15/9/10.
//  Copyright © 2015年 CHENGuo. All rights reserved.
//

#import "CGRunViewController.h"
#import "CGBetterMapView.h"
#import "CGRunningViewController.h"

@interface CGRunViewController ()
- (IBAction)startRun;
@property (weak, nonatomic) IBOutlet CGBetterMapView *mapView;
@property (nonatomic, strong) CGRunningViewController *runningViewController;
@end

@implementation CGRunViewController
- (CGRunningViewController *)runningViewController
{
    if (!_runningViewController) {
        self.runningViewController = [[CGRunningViewController alloc] initWithNibName:@"CGRunningViewController" bundle:nil];
        
        self.runningViewController.title = @"跑步";
        self.runningViewController.view.backgroundColor = [UIColor orangeColor];
    }
    
    return _runningViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



- (IBAction)startRun {
    
    [self.navigationController pushViewController:self.runningViewController animated: YES];
}


@end
