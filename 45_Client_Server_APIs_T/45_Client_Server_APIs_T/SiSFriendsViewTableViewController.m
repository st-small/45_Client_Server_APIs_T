//
//  SiSFriendsViewTableViewController.m
//  45_Client_Server_APIs_T
//
//  Created by Stanly Shiyanovskiy on 05.06.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import "SiSFriendsViewTableViewController.h"
#import "SiSServerManager.h"

@interface SiSFriendsViewTableViewController ()

@property (strong, nonatomic) NSMutableArray* friendsArray;

@end

@implementation SiSFriendsViewTableViewController

static NSInteger friendsInRequest = 5;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Мои друзья:";
    
    self.friendsArray = [NSMutableArray array];
    [self getFriendsFromServer];
    
}

#pragma mark - API

- (void) getFriendsFromServer {
    
    [[SiSServerManager sharedManager]
     getFriendsWithOffset:[self.friendsArray count]
     andCount:friendsInRequest
     onSuccess:^(NSArray *friends) {
         
         [self.friendsArray addObjectsFromArray:friends];
         
         NSMutableArray* newPaths = [NSMutableArray array];
         for (NSUInteger i = [self.friendsArray count] - [friends count]; i < [self.friendsArray count]; i++) {
             
             [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
         }
         
         [self.tableView beginUpdates];
         [self.tableView insertRowsAtIndexPaths:newPaths
                               withRowAnimation:UITableViewRowAnimationTop];
         [self.tableView endUpdates];
         
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %d", [error localizedDescription], statusCode);
     }];
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.friendsArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.row == [self.friendsArray count]) {
        
        cell.textLabel.text = @"ЗАГРУЗИТЬ ЕЩЕ...";
        
        
    } else {
        
        NSDictionary* friend = [self.friendsArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                               [friend objectForKey:@"first_name"],
                               [friend objectForKey:@"last_name"]];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        

    }
    
        return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [self.friendsArray count]) {
        
        [self getFriendsFromServer];
        
    }
}

@end
