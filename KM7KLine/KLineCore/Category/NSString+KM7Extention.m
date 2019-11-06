//
//  NSString+KM7Extention.m
//  Stark
//
//  Created by tangl on 2019/8/2.
//  Copyright © 2019 km7. All rights reserved.
//

#import "NSString+KM7Extention.h"

@implementation NSString (KM7Extention)

+ (NSString *)km7_market_getFormatPrice:(CGFloat)price basePrice:(CGFloat) basePrice{
    if(basePrice < 1){
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        formatter.usesSignificantDigits = YES;
        formatter.maximumSignificantDigits = 10;
//        formatter.maximumFractionDigits = 10;
        formatter.groupingSeparator = @"";
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
//        stringValue =
        NSString *str = [formatter stringFromNumber:@(price)];
        if(str.length < 12){
            return str;
        }
        return [str substringWithRange:NSMakeRange(0, 12)];
//        return [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:price]];
    }else if(basePrice < 10){
        return [NSString stringWithFormat:@"%.4f", price];
    }else{
        return [NSString stringWithFormat:@"%.2f", price];
    }
}
+ (NSString *)km7_market_getFormatVolume:(CGFloat)volume{
    if(volume < 1000){
        return [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:volume]];
    }else if(volume >= 1000 && volume < 1000000){
        return [NSString stringWithFormat:@"%.2f%@", volume/1000, @"千"];
    }else if(volume >=1000000 && volume < 1000000000){
        return [NSString stringWithFormat:@"%.2f%@", volume/1000000, @"百万"];
    }else{
        return [NSString stringWithFormat:@"%.2f%@", volume/1000000000, @"十亿"];
    }
}

+ (CGSize)km7_getTextWidtText:(NSString *)text  font:(UIFont *)font {
    CGSize newSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return newSize;
}
@end
