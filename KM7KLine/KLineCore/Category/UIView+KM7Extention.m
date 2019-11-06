//
//  UIView+Frame.m
//  Stark
//
//  Created by float.. on 2019/4/28.
//  Copyright © 2019 km7. All rights reserved.
//

#import "UIView+KM7Extention.h"

@implementation UIView (Frame)

+ (instancetype)viewFromNib{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)setOrigin_x:(CGFloat)origin_x{
  CGRect rect = self.frame;
  rect.origin.x = origin_x;
  self.frame = rect;
}
- (CGFloat)origin_x{
  return self.frame.origin.x;
}

- (void)setOrigin_y:(CGFloat)origin_y{
  CGRect rect = self.frame;
  rect.origin.y = origin_y;
  self.frame = rect;
}
- (CGFloat)origin_y{
  return self.frame.origin.y;
}

- (void)setSize_width:(CGFloat)size_width{
  CGRect rect = self.frame;
  rect.size.width = size_width;
  self.frame = rect;
  
}
- (CGFloat)size_width{
  return self.bounds.size.width;
}

- (void)setSize_height:(CGFloat)size_height{
  CGRect rect = self.frame;
  rect.size.height = size_height;
  self.frame = rect;
}

- (CGFloat)size_height{
  return self.bounds.size.height;
}

- (void)setCenter_x:(CGFloat)center_x{
  CGPoint center = self.center;
  center.x = center_x;
  self.center = center;
}

- (CGFloat)center_x{
  return self.center.x;
}

-(void)setCenter_y:(CGFloat)center_y{
  CGPoint center = self.center;
  center.y = center_y;
  self.center = center;
}

- (CGFloat)center_y{
  return self.center.y;
}

- (void)setBottom_y:(CGFloat)bottom_y{
  CGRect rect = self.frame;
  CGPoint point = rect.origin;
  point.y = bottom_y - rect.size.height;
  rect.origin = point;
  self.frame = rect;
}

- (CGFloat)bottom_y{
  return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)right_x{
  return CGRectGetMaxX(self.frame);
}

- (void)setRight_x:(CGFloat)right_x{
  self.origin_x = right_x - self.size_width;
}

+ (CGFloat)safeAreaInsetsBottom {
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
        return mainWindow.safeAreaInsets.bottom;
    } else {
        return 0;
    }
}

+ (CGFloat)safeAreaInsetsTop {
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [UIApplication sharedApplication].delegate.window;
        return mainWindow.safeAreaInsets.top;
    } else {
        return 20;
    }
}

@end
