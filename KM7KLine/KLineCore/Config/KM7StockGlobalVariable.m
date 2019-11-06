//
//  KM7StockGlobalVariable.m
//  Stark
//
//  Created by tangl on 2019/8/9.
//  Copyright © 2019 km7. All rights reserved.
//
#import "KM7StockGlobalVariable.h"
#import "KM7StockConstant.h"
#import "UIColor+KM7Extention.h"



/**
 *  K线图的宽度
 */
static CGFloat KM7StockChartKLineWidth = 8;

/**
 *  K线图的间隔
 */
static CGFloat KM7StockChartKLineGap = 2;


/**
 *  MainView的高度占比
 */
static CGFloat KM7StockChartKLineMainViewRadio = 0.7;

/**
 *  VolumeView的高度占比
 */
static CGFloat KM7StockChartKLineVolumeViewRadio = 0.3;



@implementation KM7StockGlobalVariable


+ (CGColorRef)klineMainViewBgColor{
    return [UIColor colorFromHexCode:@"#111D2D"].CGColor;
}

+ (CGColorRef)klineVolumeViewBgColor{
    return [UIColor blackColor].CGColor;
}

+(CGColorRef)timelineVolColor{
    return [UIColor colorFromHexCode:@"#1E507F"].CGColor;
}

+ (CGColorRef)gridLineColor{
    return [UIColor colorFromHexCode:@"#43556B"].CGColor;
}
+(CGColorRef) klineIncreaseColor{
    return [UIColor colorFromHexCode:@"#00b07c"].CGColor;
}
+(CGColorRef) klineDecreaseColor{
     return [UIColor colorFromHexCode:@"#ff5353"].CGColor;
}
+(CGColorRef) klineHighLowAssistColor{
    return [UIColor whiteColor].CGColor;
}
+(CGColorRef) klinePriceAssistColor{
    return [UIColor colorFromHexCode:@"#56667F"].CGColor;
}
+ (CGColorRef)klineTimeColor{
    return [UIColor whiteColor].CGColor;
}
+(CGColorRef)VOLColor{
    return [UIColor colorFromHexCode:@"#00BEFF"].CGColor;
}
+(CGColorRef) MA5Color{
    return [UIColor whiteColor].CGColor;
}
+(CGColorRef) MA10Color{
    return [UIColor greenColor].CGColor;
}
+(CGColorRef) MA30Color{
    return [UIColor yellowColor].CGColor;
}
+(CGColorRef) MA60Color{
    return [UIColor colorFromHexCode:@"#00beff"].CGColor;
}


+ (CGFloat)MAFontSize{
    return 10.f;
}

/**
 *  K线图的宽度
 */
+(CGFloat)kLineWidth{
    return KM7StockChartKLineWidth;
}

+(void)setkLineWith:(CGFloat)kLineWidth{
    if (kLineWidth > KM7StockChartKLineMaxWidth) {
        kLineWidth = KM7StockChartKLineMaxWidth;
    }else if (kLineWidth < KM7StockChartKLineMinWidth){
        kLineWidth = KM7StockChartKLineMinWidth;
    }
    KM7StockChartKLineWidth = kLineWidth;
}


/**
 *  K线图的间隔
 */
+(CGFloat)kLineGap{
    return KM7StockChartKLineGap;
}

+(void)setkLineGap:(CGFloat)kLineGap{
    KM7StockChartKLineGap = kLineGap;
}

/**
 *  MainView的高度占比
 */
+ (CGFloat)kLineMainViewRadio{
    return KM7StockChartKLineMainViewRadio;
}

+ (void)setkLineMainViewRadio:(CGFloat)radio{
    KM7StockChartKLineMainViewRadio = radio;
}

/**
 *  VolumeView的高度占比
 */
+ (CGFloat)kLineVolumeViewRadio{
    return KM7StockChartKLineVolumeViewRadio;
}

+ (void)setkLineVolumeViewRadio:(CGFloat)radio{
    KM7StockChartKLineVolumeViewRadio = radio;
}

@end
