//
//  COLManager.h
//  mapViewColabore
//
//  Created by Rafael Valer on 3/12/15.
//  Copyright (c) 2015 Matheus Becker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "COLUser.h"

@interface COLManager : NSObject

@property COLUser *user;

+(COLManager *)manager;

@end
