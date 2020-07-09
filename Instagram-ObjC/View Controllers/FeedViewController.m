//
//  FeedViewController.m
//  Instagram-ObjC
//
//  Created by Kristie Huang on 7/8/20.
//  Copyright © 2020 Kristie Huang. All rights reserved.
//

#import "FeedViewController.h"
#import "PostTableViewCell.h"
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Utils.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *feedTableView;
@property (nonatomic, strong) NSArray *posts;
@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.feedTableView.delegate = self;
    self.feedTableView.dataSource = self;
    [self getTimelinePosts];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self getTimelinePosts];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)getTimelinePosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post" predicate:nil];
    query.limit = 20;
    [query orderByDescending:@"updatedAt"]; //sorts by date string not by actual date lol
    [query includeKey:@"author"];
    [query includeKey:@"imageFile"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error != nil) {
            UIAlertController *alert = [Utils createAlertWithTitle:@"Network connection error." message:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            self.posts = objects;
            [self.feedTableView reloadData];
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostTableViewCell *cell = [self.feedTableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    NSDictionary *post = self.posts[indexPath.row];
    PFFileObject *imageData = post[@"imageFile"];
    [imageData getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error != nil) {
            UIAlertController *alert = [Utils createAlertWithTitle:@"Network connection error." message:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            cell.photoView.image = [UIImage imageWithData:data];
        }
    }];
    cell.usernameLabel.text = post[@"author"][@"username"];
    cell.usernameCaptLabel.text = post[@"author"][@"username"];

    cell.captionLabel.text = post[@"caption"];
    cell.timestampLabel.text = post[@"createdAt"];


    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}


@end
