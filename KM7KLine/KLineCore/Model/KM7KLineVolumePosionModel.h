//
//  KM7KLineVolumePosionModel.h
//  Stark
//
//  Created by tangl on 2019/8/9.
//  Copyright © 2019 km7. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KM7KLineVolumePosionModel : NSObject

@property (nonatomic, assign) CGPoint StartPoint;//开始点

@property (nonatomic, assign) CGPoint EndPoint;//结束点

@property (nonatomic, assign) CGColorRef color;//绘制颜色

@property (nonatomic, assign) CGFloat assestHigh; //资源最高点(k线,ma线的最高点)

@property (nonatomic, assign) NSString* assestHigh_format;
/**
 *  工厂方法
 */
+ (instancetype) modelWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint color:(CGColorRef)color;

@end

NS_ASSUME_NONNULL_END
