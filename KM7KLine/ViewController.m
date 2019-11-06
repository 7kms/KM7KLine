//
//  ViewController.m
//  KM7KLine
//
//  Created by tangl on 2019/8/18.
//  Copyright © 2019 tangl. All rights reserved.
//

#import "ViewController.h"
#import "UIView+KM7Extention.h"
#import "UIColor+KM7Extention.h"
#import "KM7StockChartView.h"

@interface ViewController ()


@property (nonatomic, strong) UIView *controlView;
@property (nonatomic, strong) KM7StockChartView *stockChartView;
@property (nonatomic, assign) KM7KlineDateType currentKlineDateType;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self setupLogical];
    
}

- (void)setupUI{
    [self.view addSubview:self.controlView];
    [self.view addSubview:self.stockChartView];
}

- (void)setupLogical{
    [self reloadKlineData];
    __weak typeof(self) weakSelf = self;
    self.stockChartView.loadMoreNoticeBlock = ^{
        [weakSelf prependKlineData];
    };
}
#pragma mark - lazy

- (KM7KlineDateType)currentKlineDateType{
    if(!_currentKlineDateType){
        _currentKlineDateType = KM7KlineDateType4Hour;
    }
    return _currentKlineDateType;
}

- (UIButton *)generateBtnWithTitle:(NSString *)title andTag:(NSInteger)tag{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    btn.backgroundColor = [UIColor colorFromHexCode:@"#00beff"];
    [btn sizeToFit];
    btn.tag = tag;
    [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIView *)controlView{
    if(!_controlView){
        _controlView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIView safeAreaInsetsTop], self.view.size_width, 40)];
        UIButton *btn1 = [self generateBtnWithTitle:@"分钟" andTag:1];
        UIButton *btn2 = [self generateBtnWithTitle:@"15分钟" andTag:2];
        UIButton *btn3 = [self generateBtnWithTitle:@"4小时" andTag:3];
        [_controlView addSubview:btn1];
        [_controlView addSubview:btn2];
        [_controlView addSubview:btn3];
        btn1.origin_x = 0;
        btn2.origin_x = 100;
        btn3.origin_x = 200;
        
    }
    return _controlView;
}
- (KM7StockChartView *)stockChartView{
    if(!_stockChartView){
        _stockChartView = [[KM7StockChartView alloc] initWithFrame:CGRectMake(0, _controlView.bottom_y, self.view.size_width, 600)];
    }
    return _stockChartView;
}


#pragma mark - events
- (void)onBtnClick:(UIButton *)sender{
    self.currentKlineDateType = sender.tag;
    [self reloadKlineData];
}

- (NSArray *)getJson{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"hb15min.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return arr;
}

- (void)reloadKlineData{
    [self.stockChartView changeLoadingStatus:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.stockChartView reloadDataWithModlesArr:[self getJson] klineType:KM7KlineChartTypeKline andDateType:self.currentKlineDateType];
    });
}

- (void)prependKlineData{
//    [self.stockChartView changeLoadingStatus:YES];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.stockChartView prependDataWithModlesArr:[self getJson] klineType:KM7KlineChartTypeKline andDateType:self.currentKlineDateType];
//    });
}
@end
