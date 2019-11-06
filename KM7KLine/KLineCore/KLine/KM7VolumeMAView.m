//
//  KM7VolumeMAView.m
//  Stark
//
//  Created by tangl on 2019/8/12.
//  Copyright © 2019 km7. All rights reserved.
//

#import "KM7VolumeMAView.h"
#import "UILabel+KM7Extention.h"
#import "UIView+KM7Extention.h"

#import "KM7StockConstant.h"
#import "KM7KLineModel.h"


@interface KM7VolumeMAView()

@property (nonatomic, strong) UILabel *volumeLabel;
@property (nonatomic, strong) UILabel *ma5Label;
@property (nonatomic, strong) UILabel *ma10Label;

@end

@implementation KM7VolumeMAView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addSubview: self.volumeLabel];
        [self addSubview: self.ma5Label];
        [self addSubview: self.ma10Label];
       
    }
    return self;
}
- (void)setChartType:(KM7KlineChartType)chartType{
    if(chartType == KM7KlineChartTypeTime){
        self.ma5Label.hidden = YES;
        self.ma10Label.hidden = YES;
    }
}

- (UILabel *)volumeLabel{
    if(!_volumeLabel){
        _volumeLabel = [UILabel km7_getLabelWithColor:[UIColor colorWithCGColor:[KM7StockGlobalVariable VOLColor]] font:[UIFont systemFontOfSize:[KM7StockGlobalVariable MAFontSize]]];
    }
    return _volumeLabel;
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


- (void)setModel:(KM7KLineModel *)model{
    static CGFloat margin = 10;
    _model = model;
    self.volumeLabel.text = [NSString stringWithFormat:@"VOL:%@", model.volume_format];
    self.ma5Label.text = [NSString stringWithFormat:@"MA5:%@", model.Volume_MA5_format];
    self.ma10Label.text = [NSString stringWithFormat:@"MA10:%@", model.Volume_MA10_format];

    
    [self.volumeLabel sizeToFit];
    [self.ma10Label sizeToFit];
    [self.ma5Label sizeToFit];
    CGFloat centerY = self.center_y - self.origin_y;;
    self.volumeLabel.origin_x = 0;
    self.volumeLabel.center_y = centerY;
    self.ma5Label.origin_x = self.volumeLabel.right_x + margin;
    self.ma5Label.center_y = centerY;
    self.ma10Label.origin_x = self.ma5Label.right_x + margin;
    self.ma10Label.center_y = centerY;
  
}

@end
