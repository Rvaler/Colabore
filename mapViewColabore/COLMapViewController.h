//
//  ViewController.h
//  mapViewColabore
//
//  Created by Matheus Becker on 06/03/15.
//  Copyright (c) 2015 Matheus Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "COLPopUpViewController.h"
#import "COLTabBarViewController.h"
#import "COLUser.h"
#import "COLManager.h"

@interface COLMapViewController : UIViewController <CLLocationManagerDelegate, UIAlertViewDelegate, MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic) BOOL localizando;
@property COLPopUpViewController *popup;
@property COLUser* user;
- (IBAction)locationUser:(id)sender;

@end

