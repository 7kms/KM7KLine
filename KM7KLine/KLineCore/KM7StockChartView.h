//
//  KM7StockChartView.h
//  Stark
//
//  Created by tangl on 2019/8/9.
//  Copyright © 2019 km7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KM7StockGlobalVariable.h"

NS_ASSUME_NONNULL_BEGIN


@interface KM7StockChartView : UIView
@property (nonatomic, copy) void(^loadMoreNoticeBlock)(void);

// 重新加载数据
- (void)reloadDataWithModlesArr:(NSArray<NSDictionary *> *)dataArr klineType:(KM7KlineChartType) klinetype andDateType:(KM7KlineDateType) dateType;

// 追加数据(加载更多)
- (void)prependDataWithModlesArr:(NSArray<NSDictionary *> *)dataArr klineType:(KM7KlineChartType) klinetype andDateType:(KM7KlineDateType) dateType;

// 追加数据(最新数据)
- (void)appendDataWithModlesArr:(NSArray<NSDictionary *> *)dataArr klineType:(KM7KlineChartType) klinetype andDateType:(KM7KlineDateType) dateType;

// 刷新最新k线
- (void)refreshLatestData:(NSDictionary *)dict;

- (void)changeLoadingStatus:(BOOL)loading;

@end

NS_ASSUME_NONNULL_END
