//
//  SiSFriend.m
//  45_Client_Server_APIs_T
//
//  Created by Stanly Shiyanovskiy on 03.06.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import "SiSFriend.h"

@implementation SiSFriend

- (id) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {
        
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName = [responseObject objectForKey:@"last_name"];
        
        NSString* urlString = [responseObject objectForKey:@"photo_100"];
        
        if (urlString) {
            
            self.imageURL = [NSURL URLWithString:urlString];
        }
        
    }
    return self;
}

@end
