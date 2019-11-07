//
//  KM7StockGlobalVariable.h
//  Stark
//
//  Created by tangl on 2019/8/9.
//  Copyright © 2019 km7. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


static const CGFloat kLineMAHeight = 30; // k线图 MA指标区域保留高度
static const CGFloat kLineTopRemainHeight = 5; // k线图顶部保留的空白区域, 可以用来画当前屏幕范围内的最低值
static const CGFloat kLineBottomRemainHeight = 15; // k线图底部保留的空白区域, 可以用来画当前屏幕范围内的最低值
static const CGFloat volumeMAHeight = 20; // 成交量 MA指标区域保留高度
static const CGFloat volumeTopRemainHeight = 2; // 成交量顶部空白区域, 不至于顶满到MA指标区域
static const CGFloat volumeBottomRemainHeight = 20; // 成交量底部空白区域, 用于绘制时间

static const int horizontalGridCount = 5; // 水平网格数量
static const int verticalGridCount = 4; // 垂直网格数量
static const CGFloat gridLineWidth = 0.5f; //网格线的宽度


// K线图类型
typedef NS_ENUM(NSUInteger, KM7KlineChartType) {
    KM7KlineChartTypeKline=1,// k线图
    KM7KlineChartTypeTime //分时图
};

//K线图
typedef NS_ENUM(NSUInteger, KM7KlineDateType) {
    KM7KlineDateTypeMin = 1,//1分
    KM7KlineDateType15Min,//15分
    KM7KlineDateTypeHour,//1小时
    KM7KlineDateType4Hour,//4小时
    KM7KlineDateTypeDay,//1天
    KM7KlineDateTypeWeek,//1周
    KM7KlineDateTypeMonth,//1月
    KM7KlineDateTypeYear,//1年
    KM7KlineDateTypeMore,//更多
};

// 初始化K线的显示位置: (展示k线图的scrollview是否需要滚到最后)
typedef NS_ENUM(NSUInteger, KM7KlineIntialDirection) {
    KM7KlineIntialDirectionStart,// scrollview滚动到最前面, 能展示出第一根k线
    KM7KlineIntialDirectionEnd,// scrollview滚动到最后面, 能展示出最后一根k线
};


@interface KM7StockGlobalVariable : UIView

+ (KM7KlineIntialDirection) initialKlineDirection;
+ (void)setInitialKlineDirection:(KM7KlineIntialDirection)direction;


//============== color config ==================
+(CGColorRef) klineMainViewBgColor; // k线背景颜色
+(CGColorRef) klineVolumeViewBgColor; // 成交量背景颜色
+(CGColorRef) timelineVolColor; // 分时图成交量柱子的颜色


+(CGColorRef) gridLineColor; //网格线颜色
+(CGColorRef) klineIncreaseColor; // 上涨颜色
+(CGColorRef) klineDecreaseColor; // 下跌颜色
+(CGColorRef) klineHighLowAssistColor; //k线图辅助色(最高点和最低点)
+(CGColorRef) klinePriceAssistColor; //k线图辅助色(价格)
+(CGColorRef) klineTimeColor; //k线图时间轴颜色
+(CGColorRef) VOLColor;
+(CGColorRef) MA5Color;
+(CGColorRef) MA10Color;
+(CGColorRef) MA30Color;
+(CGColorRef) MA60Color;

+(CGFloat) MAFontSize;

/**
 *  K线图的宽度，默认20
 */
+(CGFloat)kLineWidth;

+(void)setkLineWith:(CGFloat)kLineWidth;

/**
 *  K线图的间隔，默认1
 */
+(CGFloat)kLineGap;

+(void)setkLineGap:(CGFloat)kLineGap;

/**
 *  MainView的高度占比,默认为0.7
 */
+ (CGFloat)kLineMainViewRadio;
+ (void)setkLineMainViewRadio:(CGFloat)radio;

/**
 *  VolumeView的高度占比,默认为0.3
 */
+ (CGFloat)kLineVolumeViewRadio;
+ (void)setkLineVolumeViewRadio:(CGFloat)radio;

@end

NS_ASSUME_NONNULL_END
