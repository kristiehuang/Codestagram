//
//  PostDetailsViewController.h
//  Instagram-ObjC
//
//  Created by Kristie Huang on 7/9/20.
//  Copyright © 2020 Kristie Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostDetailsViewController : UIViewController

@property (nonatomic, strong) Post *post;
@end

NS_ASSUME_NONNULL_END
