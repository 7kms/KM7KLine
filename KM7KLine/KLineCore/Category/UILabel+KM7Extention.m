//
//  UILabel+KM7Extention.m
//  Stark
//
//  Created by float.. on 2019/7/24.
//  Copyright © 2019 km7. All rights reserved.
//

#import "UILabel+KM7Extention.h"
#import "UIView+KM7Extention.h"

@implementation UILabel (KM7Extention)

- (CGFloat)km7_getTextWidth {
  return [UILabel km7_getTextWidthWithText:self.text height:self.size_height font:self.font];
}
- (CGFloat)km7_getTextHeight {
  return [UILabel km7_getTextHeightWithText:self.text width:self.size_width font:self.font];
}
+ (CGFloat)km7_getTextWidthWithText:(NSString *)text height:(CGFloat)height font:(UIFont *)font {
  CGSize newSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
  return newSize.width;
}
+ (CGFloat)km7_getTextWidthWithText:(NSString *)text height:(CGFloat)height fontSize:(CGFloat)fontSize {
  return [UILabel km7_getTextWidthWithText:text height:height font:[UIFont systemFontOfSize:fontSize]];
}

+ (CGFloat)km7_getTextHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font {
  CGSize newSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
  return newSize.height;
}
+ (CGFloat)km7_getTextHeightWithText:(NSString *)text width:(CGFloat)width fontSize:(CGFloat)fontSize  {
  return [UILabel km7_getTextHeightWithText:text width:width font:[UIFont systemFontOfSize:fontSize]];
}

+ (instancetype)km7_getLabelWithColor:(UIColor *)color font:(UIFont *)font{
    UILabel *label = [UILabel new];
    label.textColor = color;
    label.font = font;
    return label;
}

@end
