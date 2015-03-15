//
//  User.h
//  Colaborê
//
//  Created by Rafael Valer on 3/6/15.
//  Copyright (c) 2015 com.Colaborê. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface COLUser : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *objectID;

@property (strong, nonatomic) CLLocation *userlocation;

- (id)initWithCompleteName:(NSString*)inCompleteName email:(NSString*)inEmail username:(NSString*)inUsername objectID:(NSString*)inObjectID;


@end
