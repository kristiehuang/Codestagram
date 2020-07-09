//
//  PostDetailsViewController.m
//  Instagram-ObjC
//
//  Created by Kristie Huang on 7/9/20.
//  Copyright © 2020 Kristie Huang. All rights reserved.
//

#import "PostDetailsViewController.h"
#import "Utils.h"

@interface PostDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameLabel.text = self.post.author.username;
    self.captionLabel.text = self.post.caption;
    self.timestampLabel.text = [NSString stringWithFormat:@"%@", self.post.createdAt]; //TODO: date reformat
    self.likeCountLabel.text = [NSString stringWithFormat:@"%@ likes", self.post.likeCount];

    [self.post getImageWithCompletion:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error != nil) {
            UIAlertController *alert = [Utils createAlertWithTitle:@"Network connection error." message:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            self.photoView.image = [UIImage imageWithData:data];
        }
    }];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
