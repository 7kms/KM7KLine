//
//  KM7KLinePositionModel.h
//  Stark
//
//  Created by tangl on 2019/8/9.
//  Copyright © 2019 km7. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KM7KLinePositionModel : NSObject
/**
 *  开盘点
 */
@property (nonatomic, assign) CGPoint OpenPoint;

/**
 *  收盘点
 */
@property (nonatomic, assign) CGPoint ClosePoint;

/**
 *  最高点
 */
@property (nonatomic, assign) CGPoint HighPoint;

/**
 *  最低点
 */
@property (nonatomic, assign) CGPoint LowPoint;

@property (nonatomic, assign) CGColorRef color;//绘制颜色
@property (nonatomic, assign) CGFloat high; //k线最高点 (绘制顶点需要)
@property (nonatomic, assign) CGFloat low;//k线最低点 (绘制顶点需要)

@property (nonatomic, assign) CGFloat assestHigh; //资源最高点(k线,ma线的最高点)
@property (nonatomic, assign) CGFloat assestLow;//资源最低点(k线,ma线的最低点)

/**
 *  工厂方法
 */
+ (instancetype) modelWithOpen:(CGPoint)openPoint close:(CGPoint)closePoint high:(CGPoint)highPoint low:(CGPoint)lowPoint color:(CGColorRef)color;

@end

NS_ASSUME_NONNULL_END
