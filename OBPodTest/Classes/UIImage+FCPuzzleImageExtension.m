//
//  UIImage+FCPuzzleImageExtension.m
//  FancyCam
//
//  Created by delegate on 2019/12/1.
//  Copyright © 2019 FancyCam. All rights reserved.
//

#import "UIImage+FCPuzzleImageExtension.h"


@implementation UIImage (FCPuzzleImageExtension)

static CGRect swapWidthAndHeight(CGRect rect)
{
    CGFloat  swap = rect.size.width;
    
    rect.size.width  = rect.size.height;
    rect.size.height = swap;
    
    return rect;
}

-(UIImage*)rotate:(UIImageOrientation)orient {
    CGRect             bnds = CGRectZero;
    UIImage*           copy = nil;
    CGContextRef       ctxt = nil;
    CGImageRef         imag = self.CGImage;
    CGRect             rect = CGRectZero;
    CGAffineTransform  tran = CGAffineTransformIdentity;

    rect.size.width  = CGImageGetWidth(imag);
    rect.size.height = CGImageGetHeight(imag);
    
    bnds = rect;
     switch (orient)
    {
          case UIImageOrientationUp:
                  // would get you an exact copy of the original
                   return  nil;
        case UIImageOrientationUpMirrored:
                tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
                tran = CGAffineTransformScale(tran, -1.0, 1.0);
                break;

        case UIImageOrientationDown:
                tran = CGAffineTransformMakeTranslation(rect.size.width,rect.size.height);
                tran = CGAffineTransformRotate(tran, M_PI);
                break;

        case UIImageOrientationDownMirrored:
                tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
                tran = CGAffineTransformScale(tran, 1.0, -1.0);
                break;
        case UIImageOrientationLeft:
                bnds = swapWidthAndHeight(bnds);
                tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
                tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
                break;

        case UIImageOrientationLeftMirrored:
                bnds = swapWidthAndHeight(bnds);
                tran = CGAffineTransformMakeTranslation(rect.size.height,rect.size.width);
                tran = CGAffineTransformScale(tran, -1.0, 1.0);
                tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
                break;

        case UIImageOrientationRight:
                bnds = swapWidthAndHeight(bnds);
                tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
                tran = CGAffineTransformRotate(tran, M_PI / 2.0);
                break;

        case UIImageOrientationRightMirrored:
                 bnds = swapWidthAndHeight(bnds);
                 tran = CGAffineTransformMakeScale(-1.0, 1.0);
                 tran = CGAffineTransformRotate(tran, M_PI / 2.0);
                break;

      default:
      // orientation value supplied is invalid
      return  nil;

    }

    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
    switch (orient)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
        CGContextScaleCTM(ctxt, -1.0, 1.0);
        CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
        break;
        
        default:
        CGContextScaleCTM(ctxt, 1.0, -1.0);
        CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
        break;
    }
  
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
    
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return copy;

}



+ (UIImage *)compressRatio:(UIImage *)image{
    NSData *data = UIImageJPEGRepresentation(image, 1);
    long long  dataLength = data.length;
    CGFloat targetBytes = 1024 * 300.0;
    CGFloat compressRatio = 1.0;
    if (dataLength > targetBytes) {
        compressRatio = targetBytes / dataLength;
    }
    NSString *imageName = [NSString stringWithFormat:@"%@.JPG",[self return8LetterAndNumber]] ;
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString  *jpgPath = [NSString stringWithFormat:@"%@/%@",cachePath,imageName];
    [UIImageJPEGRepresentation(image, compressRatio) writeToFile:jpgPath atomically:YES];
    UIImage *res = [UIImage imageWithContentsOfFile:jpgPath];
    return res;
}

+(NSString *)return8LetterAndNumber{
    //定义一个包含数字，大小写字母的字符串
    NSString * strAll = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    //定义一个结果
    NSString * result = [[NSMutableString alloc]initWithCapacity:16];
    for (int i = 0; i < 8; i++)
    {
        //获取随机数
        NSInteger index = arc4random() % (strAll.length-1);
        char tempStr = [strAll characterAtIndex:index];
        result = (NSMutableString *)[result stringByAppendingString:[NSString stringWithFormat:@"%c",tempStr]];
    }
    
    return result;
}

@end
