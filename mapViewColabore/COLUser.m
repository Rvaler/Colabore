//
//  User.m
//  Colaborê
//
//  Created by Rafael Valer on 3/6/15.
//  Copyright (c) 2015 com.Colaborê. All rights reserved.
//

#import "COLUser.h"
#import <Parse/Parse.h>

NSString * const keyName = @"keyUName";
NSString * const keyEmail = @"keyUEmail";
NSString * const keyUsername = @"keyUUsername";
NSString * const keyPassword = @"keyUPassword";
NSString * const keyObjID = @"keyUObjID";

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
-(void)saveData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:_name forKey:keyName];
    [defaults setObject:_email forKey:keyEmail];
    [defaults setObject:_username forKey:keyUsername];
    [defaults setObject:_objectID forKey:keyObjID];
    [defaults setObject:_password forKey:keyPassword];
    
    [defaults synchronize];
}
- (void)loadData
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:keyName])
    {
        _name = [[NSUserDefaults standardUserDefaults] objectForKey:keyName];
        _email = [[NSUserDefaults standardUserDefaults] objectForKey:keyEmail];
        _username = [[NSUserDefaults standardUserDefaults] objectForKey:keyUsername];
        _objectID = [[NSUserDefaults standardUserDefaults] objectForKey:keyObjID];
        _password = [[NSUserDefaults standardUserDefaults] objectForKey:keyPassword];
        NSLog(@"LOG");
    }
    else
    {
        _name = nil;
        _email = nil;
        _username = nil;
        _objectID = nil;
        _password = nil;
    }
}

@end




