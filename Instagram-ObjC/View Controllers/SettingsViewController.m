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

@interface SettingsViewController () <UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePickerVC;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagePickerVC = [UIImagePickerController new];
    self.imagePickerVC.allowsEditing = self;
    self.imagePickerVC.delegate = self;
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
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //camera
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    User *currentUser = [User currentUser];
    NSData *imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 1);
    currentUser.profilePicFile = [PFFileObject fileObjectWithData:imageData];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error == nil) {
            //sdfs
        } else {
            NSLog(@"prof pic update couldnt be saved");
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
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
