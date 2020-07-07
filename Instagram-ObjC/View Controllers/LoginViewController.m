//
//  ViewController.m
//  Instagram-ObjC
//
//  Created by Kristie Huang on 7/6/20.
//  Copyright © 2020 Kristie Huang. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "Utils.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)signUpButtonTapped:(id)sender {
    PFUser *user = [PFUser user];
    user[@"username"] = self.usernameTextField.text;
    user[@"password"] = self.passwordTextField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"yay");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];

        } else {
            UIAlertController *alert = [Utils createAlertWithTitle:@"Sign up did not work." message:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
}
- (IBAction)loginButtonTapped:(id)sender {

    [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (error != nil) {
            UIAlertController *alert = [Utils createAlertWithTitle:@"Login did not work." message:error.localizedDescription];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

@end
