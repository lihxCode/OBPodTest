//
//  UIImage+FCPuzzleImageExtension.h
//  FancyCam
//
//  Created by delegate on 2019/12/1.
//  Copyright © 2019 FancyCam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (FCPuzzleImageExtension)

-(UIImage*)rotate:(UIImageOrientation)orient;

+ (UIImage *)compressRatio:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
