//
//  SiSServerManager.h
//  45_Client_Server_APIs_T
//
//  Created by Stanly Shiyanovskiy on 05.06.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SiSServerManager : NSObject

+ (SiSServerManager*) sharedManager;

- (void) getFriendsWithOffset:(NSInteger)offset
                     andCount:(NSInteger)count
                    onSuccess:(void(^)(NSArray* friends))success
                    onFailure:(void(^)(NSError* error))failure;

@end
