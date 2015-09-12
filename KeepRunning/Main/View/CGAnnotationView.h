//
//  CGAnnotationView.h
//  MapAnnotationEssay
//
//  Created by CHENGuo on 15/9/11.
//  Copyright © 2015年 CHENGuo. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CGAnnotationView : MKAnnotationView
/**
 *  快速创建方法
 *
 *  @param mapView 地图
 *
 *  @return 大头针
 */
+ (instancetype)annotationViewWithMap:(MKMapView *)mapView;

@end
