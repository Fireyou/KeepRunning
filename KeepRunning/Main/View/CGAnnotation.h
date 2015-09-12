//
//  CGAnnotation.h
//  MapAnnotationEssay
//
//  Created by CHENGuo on 15/9/11.
//  Copyright © 2015年 CHENGuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CGAnnotation : NSObject<MKAnnotation>
/**
 *  大头针的位置
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
/**
 *  大头针标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  大头针的子标题
 */
@property (nonatomic, copy) NSString *subtitle;

/**
 *  图标
 */
@property (nonatomic, copy) NSString *icon;

@end
