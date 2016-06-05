//
//  SiSServerManager.m
//  45_Client_Server_APIs_T
//
//  Created by Stanly Shiyanovskiy on 05.06.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import "SiSServerManager.h"

@implementation SiSServerManager

+ (SiSServerManager*) sharedManager {
    
    static SiSServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[SiSServerManager alloc] init];
        
    });
    
    return manager;
}

- (void) getFriendsWithOffset:(NSInteger)offset
                     andCount:(NSInteger)count
                    onSuccess:(void(^)(NSArray* friends))success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode))failure {
    
    
}

@end
