//
//  CGAnnotationView.m
//  MapAnnotationEssay
//
//  Created by CHENGuo on 15/9/11.
//  Copyright © 2015年 CHENGuo. All rights reserved.
//

#import "CGAnnotationView.h"
#import "CGAnnotation.h"

@implementation CGAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        // 初始化
        // 设置大头针标题是否显示
        self.canShowCallout = YES;
        
//        // 设置大头针左边的辅助视图
//        self.leftCalloutAccessoryView = [[UISwitch alloc] init];
//        
//        // 设置大头针右边的辅助视图
//        self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    }
    return self;
}

+ (instancetype)annotationViewWithMap:(MKMapView *)mapView
{
    static NSString *identifier = @"anno";
    
    // 1.从缓存池中取
    CGAnnotationView *annoView = (CGAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    // 2.如果缓存池中没有, 创建一个新的
    if (annoView == nil) {
        
        annoView = [[CGAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:identifier];
    }
    
    return annoView;
}

//- (void)setAnnotation:(id<MKAnnotation>)annotation
- (void)setAnnotation:(CGAnnotation *)annotation
{
    [super setAnnotation:annotation];
    
    //     处理自己特有的操作
    self.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",annotation.icon ]];
    
}
@end
