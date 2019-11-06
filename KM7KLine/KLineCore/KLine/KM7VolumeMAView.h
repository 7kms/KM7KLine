//
//  KM7VolumeMAView.h
//  Stark
//
//  Created by tangl on 2019/8/12.
//  Copyright © 2019 km7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KM7StockGlobalVariable.h"
NS_ASSUME_NONNULL_BEGIN
@class KM7KLineModel;
@interface KM7VolumeMAView : UIView
@property (nonatomic, assign) KM7KlineChartType chartType;
@property (nonatomic, strong) KM7KLineModel *model;

@end

NS_ASSUME_NONNULL_END
