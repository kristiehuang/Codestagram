//
//  Post.m
//  Instagram-ObjC
//
//  Created by Kristie Huang on 7/8/20.
//  Copyright © 2020 Kristie Huang. All rights reserved.
//

#import "Post.h"
#import <Parse/Parse.h>
#import "Utils.h"

@implementation Post

@dynamic postId;
@dynamic userId;
@dynamic author;
@dynamic caption;
@dynamic imageFile;
@dynamic likeCount;
@dynamic commentCount;
@dynamic photo;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

- (void)getImageWithCompletion:(void(^)(NSData * _Nullable data, NSError * _Nullable error))completion {
    [self.imageFile getDataInBackgroundWithBlock:completion];
}

+ (void) postUserImage:(UIImage *)image withCaption:(NSString *)caption withCompletion:(PFBooleanResultBlock)completion {
    Post *newPost = [Post new];
    
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    
    newPost.imageFile = [self getPFFileFromImage:image];

    [newPost saveInBackgroundWithBlock: completion];

}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData){
        return nil;
    } else {
        return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
    }
}



@end
