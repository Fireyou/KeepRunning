//
//  CGMainTabBarController.m
//  KeepRunning
//
//  Created by CHENGuo on 15/9/10.
//  Copyright © 2015年 CHENGuo. All rights reserved.
//

#import "CGMainTabBarController.h"
#import "CGHistoryTableViewController.h"
#import "CGMusicViewController.h"
#import "CGMeTableViewController.h"
#import "CGRunViewController.h"
#import "CGMainNavigationController.h"

@interface CGMainTabBarController ()

@end

@implementation CGMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRunViewController *runVc = [[CGRunViewController alloc] initWithNibName:@"CGRunViewController" bundle:nil];
//    CGRunViewController *runVc = [[CGRunViewController alloc] init];
    [self addChildVc:runVc title:@"运动" image:@"main_tab_title_sport_0" selectedImage:@"main_tab_title_sport_1"];
    
    CGHistoryTableViewController *historyVc = [[CGHistoryTableViewController alloc] init];
    [self addChildVc:historyVc title:@"记录" image:@"main_tab_title_message_0" selectedImage:@"main_tab_title_message_1"];
    
    CGMusicViewController *musicVc = [[CGMusicViewController alloc] init];
    [self addChildVc:musicVc title:@"音乐" image:@"bottom_Icon01" selectedImage:@"bottom_Icon01_on"];
    
    CGMeTableViewController *meVc = [[CGMeTableViewController alloc] init];
    [self addChildVc:meVc title:@"我" image:@"main_tab_title_personal_0" selectedImage:@"main_tab_title_personal_1"];
    
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    //    childVc.tabBarItem.title = title; // 设置tabbar的文字
    //    childVc.navigationItem.title = title; // 设置navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    textAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    childVc.view.backgroundColor = [UIColor orangeColor];
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    CGMainNavigationController *nav = [[CGMainNavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
}

@end
