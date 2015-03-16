//
//  COLPinAnnotation.h
//  mapViewColabore
//
//  Created by Matheus Oliveira Rabelo on 16/03/15.
//  Copyright (c) 2015 Matheus Becker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface COLPinAnnotation : NSObject <MKAnnotation>
{
    NSString *title;
    NSString *subtitle;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString *)title subtitle:(NSString *)subtitle;
@end
