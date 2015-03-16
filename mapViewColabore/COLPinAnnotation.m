//
//  COLPinAnnotation.m
//  mapViewColabore
//
//  Created by Matheus Oliveira Rabelo on 16/03/15.
//  Copyright (c) 2015 Matheus Becker. All rights reserved.
//

#import "COLPinAnnotation.h"
@implementation COLPinAnnotation


@synthesize title, subtitle, coordinate;
-(id) initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString *)tit subtitle:(NSString *)sub
{
    self = [super init];
    if (self) {
        [self setCoordinate:coord];
        [self setTitle:tit];
        [self setSubtitle:sub];
    }
    return self;
}
@end
