//
//  KM7KLineModel.h
//  Stark
//
//  Created by tangl on 2019/8/9.
//  Copyright © 2019 km7. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KM7StockGlobalVariable.h"
NS_ASSUME_NONNULL_BEGIN


@interface KM7KLineModel : NSObject
/*
 {
 "timestamp": 1548201600,
 "open": 3570.93,
 "close": 3552.82,
 "low": 3514.5,
 "high": 3607.98,
 "volume_from": 23071.74,
 "volume_to": 82165371.55
 }
 */
/**
 *  日期
 */
@property (nonatomic, assign) NSInteger timestamp;

@property (nonatomic, assign)  KM7KlineDateType dateType;

/**
 *  开盘价
 */
@property (nonatomic, assign) CGFloat open;


/**
 *  收盘价
 */
@property (nonatomic, assign) CGFloat close;
/**
 *  最高价
 */
@property (nonatomic, assign) CGFloat high;

/**
 *  最低价
 */
@property (nonatomic, assign) CGFloat low;

/**
 *  成交量
 */
@property (nonatomic, assign) CGFloat volume;

/**
 *  是否是某个月的第一个交易日
 */
@property (nonatomic, assign) BOOL isFirstTradeDate;
#pragma 内部自动初始化

@property (nonatomic, copy) NSString *time_format;
@property (nonatomic, copy) NSString *open_format;
@property (nonatomic, copy) NSString *close_format;
@property (nonatomic, copy) NSString *high_format;
@property (nonatomic, copy) NSString *low_format;
@property (nonatomic, copy) NSString *volume_format;
@property (nonatomic, copy) NSString *change_format;
/**
 *  该Model及其之前所有收盘价之和
 */
@property (nonatomic, assign) double SumOfLastClose;

/**
 *  该Model及其之前所有成交量之和
 */
@property (nonatomic, assign) double SumOfLastVolume;


#pragma mark - MA线
//移动平均数分为MA（简单移动平均数）和EMA（指数移动平均数），其计算公式如下：［C为收盘价，N为周期数］：
//MA（N）=（C1+C2+……CN）/N
@property (nonatomic, assign) double MA5;
@property (nonatomic, assign) double MA10;
//MA（30）=（C1+C2+……CN）/30
@property (nonatomic, assign) double MA30;
@property (nonatomic, assign) double MA60;

@property (nonatomic, assign) double Volume_MA5;
@property (nonatomic, assign) double Volume_MA10;
@property (nonatomic, assign) double Volume_MA30;


@property (nonatomic, copy) NSString *MA5_format;
@property (nonatomic, copy) NSString *MA10_format;
@property (nonatomic, copy) NSString *MA30_format;
@property (nonatomic, copy) NSString *MA60_format;

@property (nonatomic, copy) NSString *Volume_MA5_format;
@property (nonatomic, copy) NSString *Volume_MA10_format;
@property (nonatomic, copy) NSString *Volume_MA30_format;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)modelWithDict:(NSDictionary *)dict andType: (KM7KlineDateType)dateType;

- (NSString *)calOpenMPercent:(NSString *)mtype;

@end

NS_ASSUME_NONNULL_END
