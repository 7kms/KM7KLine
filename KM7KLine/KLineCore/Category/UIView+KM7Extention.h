//
//  UIView+Frame.h
//  Stark
//
//  Created by float.. on 2019/4/28.
//  Copyright © 2019 km7. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (KM7Extention)
@property (nonatomic, assign) CGFloat size_width;
@property (nonatomic, assign) CGFloat size_height;
@property (nonatomic, assign) CGFloat origin_x;
@property (nonatomic, assign) CGFloat origin_y;
@property (nonatomic, assign) CGFloat center_x;
@property (nonatomic, assign) CGFloat center_y;
@property (nonatomic, assign) CGFloat bottom_y;
@property (nonatomic, assign) CGFloat right_x;
+(instancetype)viewFromNib;

+ (CGFloat)safeAreaInsetsTop;
+ (CGFloat)safeAreaInsetsBottom;
@end

NS_ASSUME_NONNULL_END
