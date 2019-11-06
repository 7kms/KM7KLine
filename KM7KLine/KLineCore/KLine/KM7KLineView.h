//
//  KM7KLineView.h
//  Stark
//
//  Created by tangl on 2019/8/9.
//  Copyright © 2019 km7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KM7StockGlobalVariable.h"

NS_ASSUME_NONNULL_BEGIN
@class KM7KLineModel;
@interface KM7KLineView : UIView

@property (nonatomic, assign) CGFloat startXoffset; //开始渲染的xoffset

@property (nonatomic, assign) KM7KlineChartType chartType;
- (void)reloadWithModels:(NSArray<KM7KLineModel *> *)models latestModel:(KM7KLineModel *)latestModel;
@end

NS_ASSUME_NONNULL_END
