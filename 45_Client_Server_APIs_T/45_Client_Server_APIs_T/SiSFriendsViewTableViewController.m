//
//  SiSFriendsViewTableViewController.m
//  45_Client_Server_APIs_T
//
//  Created by Stanly Shiyanovskiy on 05.06.16.
//  Copyright © 2016 Stanly Shiyanovskiy. All rights reserved.
//

#import "SiSFriendsViewTableViewController.h"
#import "SiSServerManager.h"
#import "SiSFriend.h"

@interface SiSFriendsViewTableViewController ()

@property (strong, nonatomic) NSMutableArray* friendsArray;

@end

@implementation SiSFriendsViewTableViewController

static NSInteger friendsInRequest = 5;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Мои друзья:";
    
    self.friendsArray = [NSMutableArray array];
    self.loadingData = YES;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor], NSForegroundColorAttributeName,
      [UIFont fontWithName:@"Avenir Next" size:23.0], NSFontAttributeName, nil]];
    
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
         
         self.loadingData = NO;
         
     } onFailure:^(NSError *error) {
         NSLog(@"error = %@", [error localizedDescription]);
     }];
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.friendsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    SiSFriend* friend = [self.friendsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                           friend.firstName, friend.lastName];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:friend.imageURL];
    
    __weak UITableViewCell* weakCell = cell;
    
    cell.imageView.image = nil;
    
    [cell.imageView setImageWithURLRequest:request
                          placeholderImage:[UIImage imageNamed:@"preview.gif"]
                                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                    
                                                           weakCell.imageView.image = image;
                                                           
                                                           CALayer* imageLayer = weakCell.imageView.layer;
                                                           [imageLayer setCornerRadius:22];
                                                           [imageLayer setBorderWidth:1];
                                                           [imageLayer setBorderColor:[[UIColor grayColor] CGColor]];
                                                           [imageLayer setMasksToBounds:YES];
                                   }
                                   failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                       NSLog(@"beda beda beda");
                                   }];

    
        return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    if (indexPath.row == [self.friendsArray count]) {
//        
//        [self getFriendsFromServer];
//        
//    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        if (!self.loadingData)
        {
            self.loadingData = YES;
            [self getFriendsFromServer];
        }
    }
}

@end
