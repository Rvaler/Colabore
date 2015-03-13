//
//  User.m
//  Colaborê
//
//  Created by Rafael Valer on 3/6/15.
//  Copyright (c) 2015 com.Colaborê. All rights reserved.
//

#import "COLUser.h"
#import <Parse/Parse.h>

@implementation COLUser

BOOL creationSuccessful;

- (id)initWithCompleteName:(NSString*)inCompleteName email:(NSString*)inEmail username:(NSString*)inUsername objectID:(NSString*)inObjectID
{
    self = [super init];
    if (self) {
        _objectID = inObjectID;
        _name = inCompleteName;
        _email = inEmail;
        _username = inUsername;
        //_password = inPassword;
    }
    return self;
}


@end




