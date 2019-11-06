//
//  NSString+KM7Extention.h
//  Stark
//
//  Created by tangl on 2019/8/2.
//  Copyright © 2019 km7. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (KM7Extention)

+ (NSString *)km7_market_getFormatPrice:(CGFloat)price basePrice:(CGFloat) basePrice;

+ (NSString *)km7_market_getFormatVolume:(CGFloat)volume;

+ (CGSize)km7_getTextWidtText:(NSString *)text  font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
