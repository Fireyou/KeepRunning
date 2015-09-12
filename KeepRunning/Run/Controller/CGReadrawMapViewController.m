//
//  CGReadrawMapViewController.m
//  跑跑
//
//  Created by CHENGuo on 15/9/7.
//  Copyright (c) 2015年 CHENGuo. All rights reserved.
//

#import "CGReadrawMapViewController.h"
#import <MapKit/MapKit.h>
#import "Masonry.h"
#import "CrumbPath.h"
#import "CrumbPathRenderer.h"
#import "CGAnnotation.h"
#import "CGAnnotationView.h"

@interface CGReadrawMapViewController ()<MKMapViewDelegate>
@property (nonatomic, strong) CrumbPath *crumbs;
@property (nonatomic, strong) CrumbPathRenderer *crumbPathRenderer;
@property (nonatomic, strong) MKPolygonRenderer *drawingAreaRenderer;
@property (nonatomic, strong) MKMapView *map;
@end

@implementation CGReadrawMapViewController
- (NSMutableArray *)locations
{
    if (!_locations) {
        self.locations = [[NSMutableArray alloc] init];
        
        
    }
    
    return _locations;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.map = [[MKMapView alloc] init];
    
    [self.view addSubview:self.map];
    self.view.backgroundColor = [UIColor orangeColor];
    self.map.layer.cornerRadius = 10;
    self.map.delegate = self;
    
    // 设置不允许地图旋转
    self.map.rotateEnabled = NO;
    
    
    [self.map mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.map.superview);
        make.centerX.equalTo(self.map.superview.mas_centerX);
        make.left.equalTo(self.map.superview.mas_left).offset(10);
        make.right.equalTo(self.map.superview.mas_right).offset(-10);
        make.top.equalTo(self.map.superview).offset(74);
        make.height.mas_equalTo(300);
    }];
    
    
    
    for (int i = (int)self.locations.count - 1; i > - 1 ; i--) {
        CLLocation *location = self.locations[i];
        [self drawMapLine:location];
    }

    
    CLLocation *location = self.locations[0];
    CGAnnotation *annotation = [[CGAnnotation alloc] init];
    annotation.title = @"起点";
//    annotation.subtitle = @"lplp";
    
    annotation.coordinate = location.coordinate;
    annotation.icon = @"img_map_startpoint";
    
    location = [self.locations lastObject];
    CGAnnotation *annotation1 = [[CGAnnotation alloc] init];
    annotation1.title = @"终点";
    annotation1.subtitle = @"不错，下次加油";
    
    annotation1.coordinate = location.coordinate;
    
    annotation1.icon = @"map_annotation_end";
    
    [self.map addAnnotations:@[annotation,annotation1]];
    

    
    
    
}
#pragma mark - mapKit
- (void)drawMapLine:(CLLocation *)newLocation
{
    
    
        
        if (self.crumbs == nil)
        {
            // This is the first time we're getting a location update, so create
            // the CrumbPath and add it to the map.
            //
            _crumbs = [[CrumbPath alloc] initWithCenterCoordinate:newLocation.coordinate];
            [self.map addOverlay:self.crumbs level:MKOverlayLevelAboveRoads];
            
            // on the first location update only, zoom map to user location
            CLLocationCoordinate2D newCoordinate = newLocation.coordinate;
            
            // default -boundingMapRect size is 1km^2 centered on coord
            MKCoordinateRegion region = [self coordinateRegionWithCenter:newCoordinate approximateRadiusInMeters:2500];
            
            [self.map setRegion:region animated:YES];
        }
        else
        {
            
            // This is a subsequent location update.
            //
            // If the crumbs MKOverlay model object determines that the current location has moved
            // far enough from the previous location, use the returned updateRect to redraw just
            // the changed area.
            //
            // note: cell-based devices will locate you using the triangulation of the cell towers.
            // so you may experience spikes in location data (in small time intervals)
            // due to cell tower triangulation.
            //
            BOOL boundingMapRectChanged = NO;
            MKMapRect updateRect = [self.crumbs addCoordinate:newLocation.coordinate boundingMapRectChanged:&boundingMapRectChanged];
            if (boundingMapRectChanged)
            {
                // MKMapView expects an overlay's boundingMapRect to never change (it's a readonly @property).
                // So for the MapView to recognize the overlay's size has changed, we remove it, then add it again.
                [self.map removeOverlays:self.map.overlays];
                _crumbPathRenderer = nil;
                [self.map addOverlay:self.crumbs level:MKOverlayLevelAboveRoads];
                
                MKMapRect r = self.crumbs.boundingMapRect;
                MKMapPoint pts[] = {
                    MKMapPointMake(MKMapRectGetMinX(r), MKMapRectGetMinY(r)),
                    MKMapPointMake(MKMapRectGetMinX(r), MKMapRectGetMaxY(r)),
                    MKMapPointMake(MKMapRectGetMaxX(r), MKMapRectGetMaxY(r)),
                    MKMapPointMake(MKMapRectGetMaxX(r), MKMapRectGetMinY(r)),
                };
                NSUInteger count = sizeof(pts) / sizeof(pts[0]);
                MKPolygon *boundingMapRectOverlay = [MKPolygon polygonWithPoints:pts count:count];
                [self.map addOverlay:boundingMapRectOverlay level:MKOverlayLevelAboveRoads];
            }
            else if (!MKMapRectIsNull(updateRect))
            {
                // There is a non null update rect.
                // Compute the currently visible map zoom scale
                MKZoomScale currentZoomScale = (CGFloat)(self.map.bounds.size.width / self.map.visibleMapRect.size.width);
                // Find out the line width at this zoom scale and outset the updateRect by that amount
                CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
                updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
                // Ask the overlay view to update just the changed area.
                [self.crumbPathRenderer setNeedsDisplayInMapRect:updateRect];
            }
        }
    

}
- (MKCoordinateRegion)coordinateRegionWithCenter:(CLLocationCoordinate2D)centerCoordinate approximateRadiusInMeters:(CLLocationDistance)radiusInMeters
{
    // Multiplying by MKMapPointsPerMeterAtLatitude at the center is only approximate, since latitude isn't fixed
    //
    double radiusInMapPoints = radiusInMeters*MKMapPointsPerMeterAtLatitude(centerCoordinate.latitude);
    MKMapSize radiusSquared = {radiusInMapPoints,radiusInMapPoints};
    
    MKMapPoint regionOrigin = MKMapPointForCoordinate(centerCoordinate);
    MKMapRect regionRect = (MKMapRect){regionOrigin, radiusSquared}; //origin is the top-left corner
    
    regionRect = MKMapRectOffset(regionRect, -radiusInMapPoints/2, -radiusInMapPoints/2);
    
    // clamp the rect to be within the world
    regionRect = MKMapRectIntersection(regionRect, MKMapRectWorld);
    
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(regionRect);
    return region;
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    MKOverlayRenderer *renderer = nil;
    
    if ([overlay isKindOfClass:[CrumbPath class]])
    {
        if (self.crumbPathRenderer == nil)
        {
            _crumbPathRenderer = [[CrumbPathRenderer alloc] initWithOverlay:overlay];
        }
        renderer = self.crumbPathRenderer;
    }
    else if ([overlay isKindOfClass:[MKPolygon class]])
    {
#if kDebugShowArea
        if (![self.drawingAreaRenderer.polygon isEqual:overlay])
        {
            _drawingAreaRenderer = [[MKPolygonRenderer alloc] initWithPolygon:overlay];
                                    self.drawingAreaRenderer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.25];
//            self.drawingAreaRenderer.fillColor = [UIColor clearColor];
        }
        renderer = self.drawingAreaRenderer;
#endif
    }
    
    return renderer;
}
#pragma mark - mapKit
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CGAnnotation class]] == NO) {
        return nil;
    }
    
    // 1.创建大头针
    CGAnnotationView *annoView = [CGAnnotationView annotationViewWithMap:mapView];
    // 2.设置模型
    annoView.annotation = annotation;
    
    // 3.返回大头针
    return annoView;
}


@end
