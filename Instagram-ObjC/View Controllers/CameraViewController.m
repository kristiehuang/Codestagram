//
//  CameraViewController.m
//  Instagram-ObjC
//
//  Created by Kristie Huang on 7/8/20.
//  Copyright © 2020 Kristie Huang. All rights reserved.
//

#import "CameraViewController.h"
#import "Post.h"
#import "Utils.h"

@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePickerVC;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *captionTextView;
@property (nonatomic) BOOL isPlaceholder;
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imagePickerVC = [UIImagePickerController new];
    self.imagePickerVC.delegate = self;
    self.imagePickerVC.allowsEditing = self;

    self.isPlaceholder = true;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    //do something with the images
    self.imageView.image = editedImage;
    self.isPlaceholder = false;
    [self dismissViewControllerAnimated:YES completion:nil];
    //go back to original view controller
}

- (IBAction)shareButtonTapped:(id)sender {
    NSString *caption = self.captionTextView.text;
    if (self.isPlaceholder) {
        UIAlertController *alert = [Utils createAlertWithTitle:@"No photo added!" message:@"Please take or select a photo to add."];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
//        CGSize * size = CGSizeMake((float)100, (float)100);
//        self.imageView.image = [self resizeImage:self.imageView.image withSize:size];
        [Post postUserImage:self.imageView.image withCaption:caption withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                //succeed
                NSLog(@"posted!");
                self.isPlaceholder = true;
                self.imageView.image = [UIImage imageNamed:@"image_placeholder"];;
                self.captionTextView.text = @"";
                [self.tabBarController setSelectedIndex:0];
                //clear data and pop back to FeedViewController
            } else {
                [Utils createAlertWithTitle:@"Your post couldn't be shared." message:error.localizedDescription];
            }
        }];

    }
}

- (IBAction)takePictureButtonTapped:(id)sender {
    //EDIT TODO SHOW BOTH ON CAMERA VC
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
