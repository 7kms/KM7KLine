
//
//  KM7KLineMAView.m
//  Stark
//
//  Created by tangl on 2019/8/12.
//  Copyright © 2019 km7. All rights reserved.
//

#import "KM7KLineMAView.h"
#import "KM7StockConstant.h"
#import "KM7StockGlobalVariable.h"
#import "KM7KLineModel.h"
#import "UIView+KM7Extention.h"
#import "UILabel+KM7Extention.h"

@interface KM7KLineMAView()

@property (nonatomic, strong) UILabel *ma5Label;
@property (nonatomic, strong) UILabel *ma10Label;
@property (nonatomic, strong) UILabel *ma30Label;
@property (nonatomic, strong) UILabel *ma60Label;

@end

@implementation KM7KLineMAView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addSubview: self.ma5Label];
        [self addSubview: self.ma10Label];
        [self addSubview: self.ma30Label];
        [self addSubview: self.ma60Label];
    }
    return self;
}
- (void)setChartType:(KM7KlineChartType)chartType{
    if(chartType == KM7KlineChartTypeTime){
        self.ma5Label.hidden = YES;
        self.ma10Label.hidden = YES;
        self.ma30Label.hidden = YES;
        self.ma60Label.hidden = YES;
    }
}

- (UILabel *)ma5Label{
    if(!_ma5Label){
        _ma5Label = [UILabel km7_getLabelWithColor:[UIColor colorWithCGColor:[KM7StockGlobalVariable MA5Color]] font:[UIFont systemFontOfSize:[KM7StockGlobalVariable MAFontSize]]];
    }
    return _ma5Label;
}
- (UILabel *)ma10Label{
    if(!_ma10Label){
        _ma10Label = [UILabel km7_getLabelWithColor:[UIColor colorWithCGColor:[KM7StockGlobalVariable MA10Color]] font:[UIFont systemFontOfSize:[KM7StockGlobalVariable MAFontSize]]];
    }
    return _ma10Label;
}
- (UILabel *)ma30Label{
    if(!_ma30Label){
        _ma30Label = [UILabel km7_getLabelWithColor:[UIColor colorWithCGColor:[KM7StockGlobalVariable MA30Color]] font:[UIFont systemFontOfSize:[KM7StockGlobalVariable MAFontSize]]];
    }
    return _ma30Label;
}
- (UILabel *)ma60Label{
    if(!_ma60Label){
        _ma60Label = [UILabel km7_getLabelWithColor:[UIColor colorWithCGColor:[KM7StockGlobalVariable MA60Color]] font:[UIFont systemFontOfSize:[KM7StockGlobalVariable MAFontSize]]];
    }
    return _ma60Label;
}

- (void)setModel:(KM7KLineModel *)model{
    static CGFloat margin = 10;
    _model = model;
    self.ma5Label.text = [NSString stringWithFormat:@"MA5:%@",model.MA5_format];
    self.ma10Label.text = [NSString stringWithFormat:@"MA10:%@",model.MA10_format];
    self.ma30Label.text = [NSString stringWithFormat:@"MA30:%@",model.MA30_format];
    self.ma60Label.text = [NSString stringWithFormat:@"MA60:%@",model.MA60_format];
    
    [self.ma5Label sizeToFit];
    [self.ma10Label sizeToFit];
    [self.ma30Label sizeToFit];
    [self.ma60Label sizeToFit];
    
    self.ma5Label.origin_x = 0;
    self.ma5Label.center_y = self.center_y;
    self.ma10Label.origin_x = self.ma5Label.right_x + margin;
    self.ma10Label.center_y = self.center_y;
    self.ma30Label.origin_x = self.ma10Label.right_x + margin;
    self.ma30Label.center_y = self.center_y;
    self.ma60Label.origin_x = self.ma30Label.right_x + margin;
    self.ma60Label.center_y = self.center_y;
}

@end
