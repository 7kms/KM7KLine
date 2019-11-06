//
//  UIColor+FlatUI.h
//  Stark
//
//  Created by float.. on 2019/4/28.
//  Copyright © 2019 km7. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (KM7Extention)


/**
 通过16进制字符串创建UIColor对象
 
 @param hexString 16进制字符串
 @return UIColor对象
 */
+ (UIColor *)colorFromHexCode:(NSString *)hexString;


@end

NS_ASSUME_NONNULL_END
