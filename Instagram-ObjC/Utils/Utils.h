//
//  Utils.h
//  Instagram-ObjC
//
//  Created by Kristie Huang on 7/7/20.
//  Copyright © 2020 Kristie Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject

+ (UIAlertController*)createAlertWithTitle:(NSString*) title message:(NSString*) message;

+ (void)getImageWithFile:(PFFileObject *)imageFile WithCompletion:(void(^)(NSData * _Nullable data, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
