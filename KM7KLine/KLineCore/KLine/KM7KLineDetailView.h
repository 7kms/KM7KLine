//
//  KM7KLineDetailView.h
//  Stark
//
//  Created by tangl on 2019/8/13.
//  Copyright © 2019 km7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KM7StockGlobalVariable.h"
@class KM7KLineModel;
NS_ASSUME_NONNULL_BEGIN

@interface KM7KLineDetailView : UIView
@property (nonatomic, assign) KM7KlineChartType chartType;
-(void)reloadWithModel:(KM7KLineModel *)model andCrossPoint:(CGPoint) crossPoint;//传入model和交叉点

@end

NS_ASSUME_NONNULL_END
