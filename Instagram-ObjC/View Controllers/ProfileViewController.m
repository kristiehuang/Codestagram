//
//  ProfileViewController.m
//  Instagram-ObjC
//
//  Created by Kristie Huang on 7/10/20.
//  Copyright © 2020 Kristie Huang. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Post.h"

#import "Utils.h"
#import "PostCollectionViewCell.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *currentUserPosts;
@property (nonatomic, strong) User *currentUser;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    CGFloat postsPerRow = 3;
    CGFloat viewWidth = self.collectionView.frame.size.width;
    layout.itemSize = CGSizeMake(viewWidth / postsPerRow, viewWidth / postsPerRow);
    User *user = [User currentUser];
    [self getCurrentUserPosts];
    
    self.usernameLabel.text = user.username;
    if (user.profilePicFile == nil) {
        self.profilePicView.image = [UIImage imageNamed:@"image_placeholder"];
    } else {
        [Utils getImageWithFile:user.profilePicFile WithCompletion:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"oops, error %@", error.localizedDescription);
            } else {
                self.profilePicView.image = [UIImage imageWithData:data];
            }
        }];
    }
    self.bioLabel.text = (user.bio == nil) ? @"": user.bio;
}

- (void)getCurrentUserPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post" predicate:nil];
    query.limit = 20;
    [query orderByDescending:@"updatedAt"]; //sorts by date string not by actual date lol
    [query includeKey:@"author"];
    [query includeKey:@"imageFile"];
    [query includeKey:@"createdAt"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];

    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error != nil) {
            UIAlertController *alert = [Utils createAlertWithTitle:@"Network connection error." message:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            self.currentUserPosts = objects;
            [self.collectionView reloadData];
        }
    }];
}

- (IBAction)settingsButton:(id)sender {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //do smtn
    PostCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionCell" forIndexPath:indexPath];
    Post *post = self.currentUserPosts[indexPath.item];
    [Utils getImageWithFile:post.imageFile WithCompletion:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error == nil) {
            cell.picView.image = [UIImage imageWithData:data];
        } else {
            NSLog(@"oops %@", error.localizedDescription);
        }
    }];
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.currentUserPosts.count;
}


@end
