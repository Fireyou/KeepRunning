//
//  CGBetterMapView.m
//  KeepRunning
//
//  Created by CHENGuo on 15/9/10.
//  Copyright © 2015年 CHENGuo. All rights reserved.
//

#import "CGBetterMapView.h"
#import <MapKit/MapKit.h>
#import "CrumbPath.h"
#import "CrumbPathRenderer.h"
#import "CGHeader.h"
#import "CGAnnotation.h"
#import "CGAnnotationView.h"

#define kDebugShowArea 1

@interface CGBetterMapView()<MKMapViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) CrumbPath *crumbs;
@property (nonatomic, strong) CrumbPathRenderer *crumbPathRenderer;
@property (nonatomic, strong) MKPolygonRenderer *drawingAreaRenderer;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation CGBetterMapView
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        
        self.layer.cornerRadius = 7;
        self.clipsToBounds = YES;
        
    }
    return self;
    
}
- (void)settingsDidChange:(NSNotification *)notification
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    
    // update our location manager for these settings changes:
    
    // accuracy (CLLocationAccuracy)
    CLLocationAccuracy desiredAccuracy = [settings doubleForKey:LocationTrackingAccuracyPrefsKey];
    self.locationManager.desiredAccuracy = desiredAccuracy;
    
    // note:
    // for "PlaySoundOnLocationUpdatePrefsKey", code to play the sound later will read this default value
    // for "TrackLocationInBackgroundPrefsKey", code to track location in background will read this default value
}
- (void)awakeFromNib
{
    self.map = [self.subviews firstObject];
    self.map.delegate = self;
    
    //设置追踪模式
    //    self.map.userTrackingMode = MKUserTrackingModeFollow;
    self.map.showsUserLocation = YES;
    
    
    
    [self initilizeLocationTracking];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(settingsDidChange:)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
    
    // 设置不允许地图旋转
    self.map.rotateEnabled = NO;
    
}
- (void)dealloc
{
    // even though we are using ARC we still need to:
    
    // 1) properly balance the unregister from the NSNotificationCenter,
    // which was registered previously in "viewDidLoad"
    //
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 2) manually unregister for delegate callbacks,
    // As of iOS 7, most system objects still use __unsafe_unretained delegates for compatibility.
    //
    self.locationManager.delegate = nil;
    
}
#pragma mark - SwitchMode
- (void)handleUIApplicationDidEnterBackgroundNotification:(NSNotification *)note
{
    [self switchToBackgroundMode:YES];
}

- (void)handleUIApplicationWillEnterForegroundNotification :(NSNotification *)note
{
    [self switchToBackgroundMode:NO];
}

// called when the app is moved to the background (user presses the home button) or to the foreground
//
- (void)switchToBackgroundMode:(BOOL)background
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:TrackLocationInBackgroundPrefsKey])
    {
        return; // nothing to do, just keep tracking location
    }
    
    if (background)
    {
        [self.locationManager stopUpdatingLocation];
    }
    else
    {
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - Location Tracking

- (void)initilizeLocationTracking
{
    _locationManager = [[CLLocationManager alloc] init];
    assert(self.locationManager);
    
    self.locationManager.delegate = self; // tells the location manager to send updates to this object
    
    // iOS 8 introduced a more powerful privacy model: <https://developer.apple.com/videos/wwdc/2014/?id=706>.
    // We use -respondsToSelector: to only call the new authorization API on systems that support it.
    //
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
        
        // note: doing so will provide the blue status bar indicating iOS
        // will be tracking your location, when this sample is backgrounded
    }
    
    // By default we use the best accuracy setting (kCLLocationAccuracyBest)
    //
    // You may instead want to use kCLLocationAccuracyBestForNavigation, which is the highest possible
    // accuracy and combine it with additional sensor data.  Note that level of accuracy is intended
    // for use in navigation applications that require precise position information at all times and
    // are intended to be used only while the device is plugged in.
    //
    self.locationManager.desiredAccuracy =
    [[NSUserDefaults standardUserDefaults] doubleForKey:LocationTrackingAccuracyPrefsKey];
    //    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // start tracking the user's location
    [self.locationManager startUpdatingLocation];
    
    // Observe the application going in and out of the background, so we can toggle location tracking.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUIApplicationDidEnterBackgroundNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUIApplicationWillEnterForegroundNotification:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    if (locations != nil && locations.count > 0)
    {
        
        
        // we are not using deferred location updates, so always use the latest location
        CLLocation *newLocation = locations[0];
        
        //自己写的代理
        if ([self.delegate respondsToSelector:@selector(locationManager:didUpdateNewLocation:)]) {
            [self.delegate locationManager:manager didUpdateNewLocation:newLocation];
            
            // 一次性执行：
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                
                CGAnnotation *annotation = [[CGAnnotation alloc] init];
                annotation.title = @"起点";
                annotation.subtitle = @"赶紧跑啊！看什么看！";
                
                annotation.coordinate = newLocation.coordinate;
                annotation.icon = @"img_map_startpoint";
                
                
                [self.map addAnnotation:annotation];
                
                
            });
        }
        
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
}
static NSString *DescriptionOfCLAuthorizationStatus(CLAuthorizationStatus st)
{
    switch (st)
    {
        case kCLAuthorizationStatusNotDetermined:
            return @"kCLAuthorizationStatusNotDetermined";
        case kCLAuthorizationStatusRestricted:
            return @"kCLAuthorizationStatusRestricted";
        case kCLAuthorizationStatusDenied:
            return @"kCLAuthorizationStatusDenied";
            //case kCLAuthorizationStatusAuthorized: is the same as
            //kCLAuthorizationStatusAuthorizedAlways
        case kCLAuthorizationStatusAuthorizedAlways:
            return @"kCLAuthorizationStatusAuthorizedAlways";
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return @"kCLAuthorizationStatusAuthorizedWhenInUse";
    }
    return [NSString stringWithFormat:@"Unknown CLAuthorizationStatus value: %d", st];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"%s:%d %@", __func__, __LINE__, DescriptionOfCLAuthorizationStatus(status));
}
#pragma mark - MapKit

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
            //                        self.drawingAreaRenderer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.25];
            self.drawingAreaRenderer.fillColor = [UIColor clearColor];
        }
        renderer = self.drawingAreaRenderer;
#endif
    }
    
    return renderer;
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setObject:@(mode) forKey:UserTrackingModePrefsKey];
    
}
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
