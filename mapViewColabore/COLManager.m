//
//  COLManager.m
//  mapViewColabore
//
//  Created by Rafael Valer on 3/12/15.
//  Copyright (c) 2015 Matheus Becker. All rights reserved.
//

#import "COLManager.h"

@implementation COLManager

+(COLManager *)manager
{
    static COLManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _user = [[COLUser alloc] init];
    }
    return self;
}

@end
