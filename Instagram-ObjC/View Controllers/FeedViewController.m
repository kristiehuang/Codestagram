//
//  FeedViewController.m
//  Instagram-ObjC
//
//  Created by Kristie Huang on 7/8/20.
//  Copyright © 2020 Kristie Huang. All rights reserved.
//

#import "FeedViewController.h"
#import "Post.h"
#import "PostTableViewCell.h"
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Utils.h"
#import "PostDetailsViewController.h"


@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *feedTableView;
@property (nonatomic, strong) NSArray<Post *> *posts;
@property (nonatomic, strong) UIRefreshControl * refreshControl;
@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.feedTableView.delegate = self;
    self.feedTableView.dataSource = self;
    self.feedTableView.rowHeight = UITableViewAutomaticDimension;
    [self getTimelinePosts];

    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(getTimelinePosts) forControlEvents:UIControlEventValueChanged];
    [self.feedTableView insertSubview:self.refreshControl atIndex:0];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self getTimelinePosts];

}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self performSegueWithIdentifier:@"detailsSegue" sender:nil];
//
//}

#pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([[segue identifier] isEqualToString:@"detailsSegue"]) {
         PostDetailsViewController *detailsVC = [segue destinationViewController];
         Post *thisPost = [sender post];
         detailsVC.post = thisPost;
     }
     
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
 }
 
- (void)getTimelinePosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post" predicate:nil];
    query.limit = 20;
    [query orderByDescending:@"updatedAt"]; //sorts by date string not by actual date lol
    [query includeKey:@"author"];
    [query includeKey:@"imageFile"];
    [query includeKey:@"createdAt"];

    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error != nil) {
            UIAlertController *alert = [Utils createAlertWithTitle:@"Network connection error." message:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            self.posts = objects;
            [self.feedTableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostTableViewCell *cell = [self.feedTableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    cell.post = self.posts[indexPath.row];
    
    [Utils getImageWithFile:cell.post.imageFile WithCompletion:^(NSData * _Nullable data, NSError * _Nullable error) {
      if (error != nil) {
            UIAlertController *alert = [Utils createAlertWithTitle:@"Network connection error." message:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            cell.photoView.image = [UIImage imageWithData:data];
        }
    }];
    
    cell.usernameLabel.text = cell.post[@"author"][@"username"];
    cell.usernameCaptLabel.text = cell.post[@"author"][@"username"];

    cell.captionLabel.text = cell.post[@"caption"];
    cell.timestampLabel.text = [NSString stringWithFormat:@"%@", cell.post.createdAt]; //TODO: reformat date


    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}


@end
