//
//  CGBetterMapView.h
//  KeepRunning
//
//  Created by CHENGuo on 15/9/10.
//  Copyright © 2015年 CHENGuo. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class CGBetterMapView;
@protocol CGBetterMapViewDelegate <NSObject>
@optional
- (void)locationManager:(CLLocationManager *)manager didUpdateNewLocation:(CLLocation *)userLocation;
- (MKUserLocation *)betterMapViewDemandForFirstCoordinate;
@end

@interface CGBetterMapView : UIView
@property (nonatomic, weak) id<CGBetterMapViewDelegate> delegate;
@property (nonatomic, weak) MKMapView *map;
@end