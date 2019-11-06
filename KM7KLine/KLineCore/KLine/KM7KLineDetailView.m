//
//  KM7KLineDetailView.m
//  Stark
//
//  Created by tangl on 2019/8/13.
//  Copyright © 2019 km7. All rights reserved.
//

#import "KM7KLineDetailView.h"
#import "KM7KLineModel.h"
#import "KM7StockGlobalVariable.h"
#import "UIView+KM7Extention.h"
#import "UILabel+KM7Extention.h"

@interface KM7KLineDetailView ()

@property (nonatomic, strong) UIStackView *contentView; // 展示详细信息的view
@property (nonatomic, strong) UIView *horizontalView;
@property (nonatomic, strong) CAGradientLayer *verticalLayer;
@property (nonatomic, strong) UIView *pointView;

// ============ 详细信息label ==================
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *openLabel;
@property (nonatomic, strong) UILabel *closeLabel;
@property (nonatomic, strong) UILabel *highLabel;
@property (nonatomic, strong) UILabel *lowLabel;
@property (nonatomic, strong) UILabel *volumeLabel;
@property (nonatomic, strong) UILabel *changeLabel;

@property (nonatomic, strong) UILabel *percentOpenM5Label;
@property (nonatomic, strong) UILabel *percentOpenM10Label;
@property (nonatomic, strong) UILabel *percentOpenM30Label;
@property (nonatomic, strong) UILabel *percentOpenM60Label;


@property (nonatomic, strong) UILabel *timeLabel;// 显示纵轴时间
@property (nonatomic, strong) UILabel *priceLabel;// 显示横轴价格


@end

@implementation KM7KLineDetailView
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.dateLabel = [self generateValueLabel];
        self.openLabel = [self generateValueLabel];
        self.closeLabel = [self generateValueLabel];
        self.highLabel = [self generateValueLabel];
        self.lowLabel = [self generateValueLabel];
        self.volumeLabel = [self generateValueLabel];
        self.changeLabel = [self generateValueLabel];
        
        self.percentOpenM5Label = [self generateValueLabel];
        self.percentOpenM10Label = [self generateValueLabel];
        self.percentOpenM30Label = [self generateValueLabel];
        self.percentOpenM60Label = [self generateValueLabel];
        
        [self.layer addSublayer:self.verticalLayer];
        [self addSubview:self.pointView];
        [self addSubview:self.horizontalView];
        [self addSubview:self.contentView];
        [self addSubview:self.timeLabel];
        [self addSubview:self.priceLabel];
    }
    return self;
}
- (UILabel *)generateValueLabel{
    return [UILabel km7_getLabelWithColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12]];
}
-(UIStackView *)generateItemViewWithTip:(NSString *)text andValueLabel:(UILabel *)valueLabel{
    UILabel *tipLabel = [UILabel km7_getLabelWithColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12]];
    tipLabel.text = text;
    UIStackView *itemView = [[UIStackView alloc] initWithArrangedSubviews:@[tipLabel,valueLabel]];
    itemView.axis = UILayoutConstraintAxisHorizontal;
    itemView.alignment = UIStackViewAlignmentCenter;
    itemView.distribution = UIStackViewDistributionFill;
    return itemView;
}

#pragma mark - lazy ui
- (UIStackView *)contentView{
    if(!_contentView){
        UIStackView *stackView = [[UIStackView alloc] initWithFrame:CGRectMake(0, kLineMAHeight, self.frame.size.width/3, 180)];
        UIView *borderView = [[UIView alloc] initWithFrame:stackView.bounds];
        borderView.layer.cornerRadius = 4;
        borderView.layer.borderColor = [UIColor whiteColor].CGColor;
        borderView.layer.borderWidth = 1/[UIScreen mainScreen].scale;
        borderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        borderView.backgroundColor = [UIColor colorWithCGColor: [KM7StockGlobalVariable klineMainViewBgColor]];
        [stackView insertSubview:borderView atIndex:0];
        stackView.layoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        stackView.layoutMarginsRelativeArrangement = YES;
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.alignment = UIStackViewAlignmentFill;
        stackView.distribution = UIStackViewDistributionEqualSpacing;
        [stackView addArrangedSubview:[self generateItemViewWithTip:@"日期" andValueLabel:self.dateLabel]];
        [stackView addArrangedSubview:[self generateItemViewWithTip:@"开盘" andValueLabel:self.openLabel]];
        [stackView addArrangedSubview:[self generateItemViewWithTip:@"收盘" andValueLabel:self.closeLabel]];
        [stackView addArrangedSubview:[self generateItemViewWithTip:@"高" andValueLabel:self.highLabel]];
        [stackView addArrangedSubview:[self generateItemViewWithTip:@"低" andValueLabel:self.lowLabel]];
        [stackView addArrangedSubview:[self generateItemViewWithTip:@"涨幅" andValueLabel:self.changeLabel]];
        
        [stackView addArrangedSubview:[self generateItemViewWithTip:@"open/M5" andValueLabel:self.percentOpenM5Label]];
        [stackView addArrangedSubview:[self generateItemViewWithTip:@"open/M10" andValueLabel:self.percentOpenM10Label]];
        [stackView addArrangedSubview:[self generateItemViewWithTip:@"open/M30" andValueLabel:self.percentOpenM30Label]];
        [stackView addArrangedSubview:[self generateItemViewWithTip:@"open/M60" andValueLabel:self.percentOpenM60Label]];
        
        [stackView addArrangedSubview:[self generateItemViewWithTip:@"成交量" andValueLabel:self.volumeLabel]];
        _contentView = stackView;
        
    }
    return _contentView;
}
- (void)setChartType:(KM7KlineChartType)chartType{
    _chartType = chartType;
    if(_chartType != KM7KlineChartTypeKline){
        _contentView.hidden = YES;
    }
}
-(UIView *)horizontalView{
    if(!_horizontalView){
        _horizontalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size_width, 1/[UIScreen mainScreen].scale)];
        _horizontalView.backgroundColor = [UIColor whiteColor];
    }
    return _horizontalView;
}
- (CAGradientLayer *)verticalLayer{
    if(!_verticalLayer){
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, kLineMAHeight, 1, self.size_height - kLineMAHeight);
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1);
        CGColorRef color1 = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.1].CGColor;
        CGColorRef color2 = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.4].CGColor;
        CGColorRef color3 = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.1].CGColor;
        gradientLayer.colors = @[(__bridge id)color1,(__bridge id)color2,(__bridge id)color3];
        gradientLayer.locations = @[@0, @0.5,@1];
        _verticalLayer = gradientLayer;
    }
    return _verticalLayer;
}
- (UIView *)pointView{
    if(!_pointView){
        _pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
        _pointView.layer.cornerRadius = 2;
        _pointView.layer.masksToBounds = YES;
        _pointView.backgroundColor = [UIColor whiteColor];
        
    }
    return _pointView;
}

- (UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [UILabel km7_getLabelWithColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12]];
        _timeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _timeLabel.layer.borderWidth = 1/[UIScreen mainScreen].scale;
        _timeLabel.backgroundColor = [UIColor colorWithCGColor:[KM7StockGlobalVariable klineVolumeViewBgColor]];
    }
    return _timeLabel;
    
}

- (UILabel *)priceLabel{
    if(!_priceLabel){
        _priceLabel = [UILabel km7_getLabelWithColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12]];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _priceLabel.layer.borderWidth = 1/[UIScreen mainScreen].scale;
        _priceLabel.backgroundColor = [UIColor colorWithCGColor:[KM7StockGlobalVariable klineMainViewBgColor]];
    }
    return _priceLabel;
}

- (void)reloadWithModel:(KM7KLineModel *)model andCrossPoint:(CGPoint)crossPoint{
    self.hidden = NO;
    // 1.更新展示框
    self.dateLabel.text = model.time_format;
    self.openLabel.text = model.open_format;
    self.highLabel.text = model.high_format;
    self.lowLabel.text = model.low_format;
    self.changeLabel.text = model.change_format;
    self.closeLabel.text = model.close_format;
    self.volumeLabel.text = model.volume_format;
    self.percentOpenM5Label.text = [model calOpenMPercent:@"MA5"];
    self.percentOpenM10Label.text = [model calOpenMPercent:@"MA10"];
    self.percentOpenM30Label.text = [model calOpenMPercent:@"MA30"];
    self.percentOpenM60Label.text = [model calOpenMPercent:@"MA60"];
    // 2.更新横轴
    self.horizontalView.center_y = crossPoint.y;
    self.priceLabel.text = model.close_format;
    [self.priceLabel sizeToFit];
    self.priceLabel.size_height = self.priceLabel.size_height + 10;
    self.priceLabel.size_width = self.priceLabel.size_width + 10;
    self.priceLabel.center_y = crossPoint.y;
    
    // 3.更新纵轴
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
      self.verticalLayer.frame = CGRectMake(crossPoint.x - [KM7StockGlobalVariable kLineWidth]/2, self.verticalLayer.frame.origin.y, [KM7StockGlobalVariable kLineWidth], self.verticalLayer.frame.size.height);
    [CATransaction commit];
  
    
    
    self.timeLabel.text = model.time_format;
    [self.timeLabel sizeToFit];
    self.timeLabel.size_height = volumeBottomRemainHeight;
    self.timeLabel.center_x = crossPoint.x;
    self.timeLabel.bottom_y = self.bottom_y;
    //4.调整位置
    if(crossPoint.x < self.size_width/2){
        self.contentView.right_x = self.right_x;
        self.priceLabel.origin_x = 0;
    }else{
        self.contentView.origin_x = self.origin_x;
        self.priceLabel.right_x = self.right_x;
    }
}

@end
