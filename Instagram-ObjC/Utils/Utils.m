//
//  Utils.m
//  Instagram-ObjC
//
//  Created by Kristie Huang on 7/7/20.
//  Copyright © 2020 Kristie Huang. All rights reserved.
//

#import "Utils.h"
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@implementation Utils

+ (UIAlertController*)createAlertWithTitle:(NSString*) title message:(NSString*) message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    return alert;
}

+ (void)getImageWithFile:(PFFileObject *)imageFile WithCompletion:(void(^)(NSData * _Nullable data, NSError * _Nullable error))completion {
    [imageFile getDataInBackgroundWithBlock:completion];
}

@end

