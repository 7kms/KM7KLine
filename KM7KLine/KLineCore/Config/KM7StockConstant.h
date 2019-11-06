//
//  KM7StockConstant.h
//  Stark
//
//  Created by tangl on 2019/8/9.
//  Copyright © 2019 km7. All rights reserved.
//

#ifndef KM7StockConstant_h
#define KM7StockConstant_h

/**
 *  K线最大的宽度
 */
#define KM7StockChartKLineMaxWidth 20

/**
 *  K线图最小的宽度
 */
#define KM7StockChartKLineMinWidth 2

/**
 *  K线图缩放界限
 */
#define KM7StockChartScaleBound 0.03

/**
 *  K线的缩放因子
 */
#define KM7StockChartScaleFactor 0.03

/**
 *  UIScrollView的contentOffset属性
 */
#define KM7StockChartContentOffsetKey @"contentOffset"

/**
 *  时分线的宽度
 */
#define KM7StockChartTimeLineLineWidth 0.5

/**
 *  时分线图的Above上最小的X
 */
#define KM7StockChartTimeLineMainViewMinX 0.0

/**
 *  分时线的timeLabelView的高度
 */
#define KM7StockChartTimeLineTimeLabelViewHeight 19

/**
 *  时分线的成交量的线宽
 */
#define KM7StockChartTimeLineVolumeLineWidth 0.5

/**
 *  长按时的线的宽度
 */
#define KM7StockChartLongPressVerticalViewWidth 0.5

/**
 *  MA线的宽度
 */
#define KM7StockChartMALineWidth 0.8

/**
 *  上下影线宽度
 */
#define KM7StockChartShadowLineWidth 1
/**
 *  所有profileView的高度
 */
#define KM7StockChartProfileViewHeight 50

/**
 *  K线图上可画区域最小的Y
 */
#define KM7StockChartKLineMainViewMinY 20

/**
 *  K线图上可画区域最大的Y
 */
#define KM7StockChartKLineMainViewMaxY (self.frame.size.height - 15)

/**
 *  K线图的成交量上最小的Y
 */
#define KM7StockChartKLineVolumeViewMinY 20

/**
 *  K线图的成交量最大的Y
 */
#define KM7StockChartKLineVolumeViewMaxY (self.frame.size.height - 20)

/**
 *  K线图的副图上最小的Y
 */
#define KM7StockChartKLineAccessoryViewMinY 20

/**
 *  K线图的副图最大的Y
 */
#define KM7StockChartKLineAccessoryViewMaxY (self.frame.size.height)

/**
 *  K线图的副图中间的Y
 */
//#define KM7StockChartKLineAccessoryViewMiddleY (self.frame.size.height-20)/2.f + 20
#define KM7StockChartKLineAccessoryViewMiddleY (maxY - (0.f-minValue)/unitValue)

/**
 *  时分线图的Above上最小的Y
 */
#define KM7StockChartTimeLineMainViewMinY 0

/**
 *  时分线图的Above上最大的Y
 */
#define KM7StockChartTimeLineMainViewMaxY (self.frame.size.height-KM7StockChartTimeLineTimeLabelViewHeight)


/**
 *  时分线图的Above上最大的Y
 */
#define KM7StockChartTimeLineMainViewMaxX (self.frame.size.width)

/**
 *  时分线图的Below上最小的Y
 */
#define KM7StockChartTimeLineVolumeViewMinY 0

/**
 *  时分线图的Below上最大的Y
 */
#define KM7StockChartTimeLineVolumeViewMaxY (self.frame.size.height)

/**
 *  时分线图的Below最大的X
 */
#define KM7StockChartTimeLineVolumeViewMaxX (self.frame.size.width)

/**
 * 时分线图的Below最小的X
 */
#define KM7StockChartTimeLineVolumeViewMinX 0
#endif /* KM7StockConstant_h */
