//
//  User.h
//  Instagram-ObjC
//
//  Created by Kristie Huang on 7/10/20.
//  Copyright © 2020 Kristie Huang. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser<PFSubclassing>

@property (nonatomic, strong) PFFileObject *profilePicFile;
@property (nonatomic, strong) NSString *bio;

@end

NS_ASSUME_NONNULL_END
