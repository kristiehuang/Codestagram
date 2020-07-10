//
//  SettingsViewController.m
//  Instagram-ObjC
//
//  Created by Kristie Huang on 7/7/20.
//  Copyright © 2020 Kristie Huang. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "SceneDelegate.h"
#import "Utils.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "User.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)logoutButtonTapped:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error != nil) {
            [self presentViewController:[Utils createAlertWithTitle:@"Error logging out." message:error.localizedDescription] animated:YES completion:nil];
        } else {
            SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            myDelegate.window.rootViewController = loginVC;
        }
    }];
}

- (IBAction)updateProfilePicTapped:(id)sender {
    User *currentUser = [User currentUser];
    
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
