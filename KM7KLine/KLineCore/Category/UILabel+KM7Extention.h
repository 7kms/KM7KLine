//
//  UILabel+KM7Extention.h
//  Stark
//
//  Created by float.. on 2019/7/24.
//  Copyright © 2019 km7. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (KM7Extention)


/**
 获取文本内容的宽度，获取宽度前先给label高度
 
 @return 宽度
 */
- (CGFloat)km7_getTextWidth;

/**
 获取文本内容的高度，获取高度前先给label宽度
 
 @return 高度
 */
- (CGFloat)km7_getTextHeight;

+ (CGFloat)km7_getTextWidthWithText:(NSString *)text height:(CGFloat)height font:(UIFont *)font;
+ (CGFloat)km7_getTextWidthWithText:(NSString *)text height:(CGFloat)height fontSize:(CGFloat)fontSize;
+ (CGFloat)km7_getTextHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font;
+ (CGFloat)km7_getTextHeightWithText:(NSString *)text width:(CGFloat)width fontSize:(CGFloat)fontSize;

+ (instancetype)km7_getLabelWithColor:(UIColor *)color font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
