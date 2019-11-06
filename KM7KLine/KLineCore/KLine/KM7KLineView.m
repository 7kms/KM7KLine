
//
//  KM7KLineView.m
//  Stark
//
//  Created by tangl on 2019/8/9.
//  Copyright © 2019 km7. All rights reserved.
//

#import "KM7KLineView.h"
#import "KM7KLineDetailView.h"
#import "KM7KLineMAView.h"
#import "KM7VolumeMAView.h"
#import "KM7KLineModel.h"
#import "KM7StockConstant.h"
#import "KM7StockGlobalVariable.h"
#import "KM7KLinePositionModel.h"
#import "KM7KLineVolumePosionModel.h"
#import "NSString+KM7Extention.h"

@interface KM7KLineView()<UIGestureRecognizerDelegate>



@property (nonatomic, strong) NSArray<KM7KLineModel *> *modelsArr;
@property (nonatomic, strong) KM7KLineModel *latestModel;

@property (nonatomic, strong) CAShapeLayer *klineLayer;
@property (nonatomic, strong) CAShapeLayer *volumeLayer;
@property (nonatomic, strong) KM7KLineDetailView *detailView;

@property (nonatomic, weak, readonly) UIScrollView *scrollView;// 父视图scrollview
@property (nonatomic, strong) KM7KLineMAView *klineMAView;
@property (nonatomic, strong) KM7VolumeMAView *volumeMAView;

// ============ k线图
@property (nonatomic, assign) CGFloat klineUnitHeight;//1dp代表的k线图价格单元, (单位: price/dp)
@property (nonatomic, strong) NSMutableArray<KM7KLinePositionModel *> *KLinePositionModels;//需要绘制的model位置数组
@property (nonatomic, strong) KM7KLinePositionModel *highestPositionModel;//当前屏幕的最高点
@property (nonatomic, strong) KM7KLinePositionModel *lowestestPositionModel;//当前屏幕的最低点
@property (nonatomic, strong) NSMutableArray *MA5Positions; // MA5位置数组
@property (nonatomic, strong) NSMutableArray *MA10Positions; //MA10位置数组
@property (nonatomic, strong) NSMutableArray *MA30Positions; //MA30位置数组
@property (nonatomic, strong) NSMutableArray *MA60Positions; //MA30位置数组

// ============= 最新价



// ================ volume成交量
@property (nonatomic, strong) NSMutableArray<KM7KLineVolumePosionModel *> *VolumePositionModels;//需要绘制的成交量的位置模型数组
@property (nonatomic, strong) KM7KLineVolumePosionModel *highestVolumePositionModel;
@property (nonatomic, strong) NSMutableArray *Volume_MA5Positions; //Volume_MA5位置数组
@property (nonatomic, strong) NSMutableArray *Volume_MA10Positions;//Volume_MA10位置数组
@property (nonatomic, strong) NSMutableArray *Volume_MA30Positions; //Volume_MA30位置数组

@property (nonatomic, assign) NSInteger startXPosition; //Index开始X的值

@end



@implementation KM7KLineView
#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame: frame]){
        [self.layer addSublayer:self.klineLayer];
        [self.layer addSublayer:self.volumeLayer];
        [self.layer addSublayer:self.volumeMAView.layer];
        [self.layer addSublayer:self.klineMAView.layer];
        [self addSubview:self.detailView];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressEvent:)];
        [self addGestureRecognizer:longPress];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapEvent:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - lifecycle
- (void)didMoveToSuperview{
    _scrollView = (UIScrollView *)self.superview;
    [super didMoveToSuperview];
}

#pragma mark - set get

- (void)setChartType:(KM7KlineChartType)chartType{
    _chartType = chartType;
    self.detailView.chartType = chartType;
    self.klineMAView.chartType = chartType;
    self.volumeMAView.chartType = chartType;
}

- (CGFloat)startXoffset{
    if(!_startXoffset){
        _startXoffset = 0;
    }
    return _startXoffset;
}

- (NSInteger)startXPosition{
   return self.startXoffset + [KM7StockGlobalVariable kLineWidth]/2;
}

#pragma mark - UIGestureRecognizerDelegate

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    return YES;
//}

#pragma mark - event
- (void)onLongPressEvent:(UILongPressGestureRecognizer *)longPress{
    static CGFloat oldPositionX = 0;
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state){
        CGPoint location = [longPress locationInView:self];
        if(ABS(oldPositionX - location.x) < ([KM7StockGlobalVariable kLineWidth] + [KM7StockGlobalVariable kLineGap])/2){
            return;
        }
        oldPositionX = location.x;
        //暂停滑动
        self.scrollView.scrollEnabled = NO;
        //根据location反解出当前选中的model
        NSUInteger index =  location.x/([KM7StockGlobalVariable kLineWidth] + [KM7StockGlobalVariable kLineGap]);
        if(index < self.modelsArr.count){//显示detail view
            [self private_showDetailViewWithModelIndex:index];
        }
    }
    if(longPress.state == UIGestureRecognizerStateEnded){
        //恢复scrollView的滑动
        self.scrollView.scrollEnabled = YES;
    }
}
- (void)onTapEvent:(UITapGestureRecognizer *)tap{
    CGPoint location = [tap locationInView:self];
    if([self.klineLayer containsPoint:location]){
        //根据location反解出当前选中的model
        NSUInteger index =  location.x/([KM7StockGlobalVariable kLineWidth] + [KM7StockGlobalVariable kLineGap]);
        if(index < self.modelsArr.count){//显示detail view
            [self private_showDetailViewWithModelIndex:index];
        }
    }else{
        [self private_hideDetailView];
    }
    
}


#pragma mark - lazy ui

- (KM7KLineDetailView *)detailView{
    if(!_detailView){
        _detailView = [[KM7KLineDetailView alloc] initWithFrame:self.bounds];
        _detailView.hidden = YES;
    }
    return _detailView;
}

- (KM7KLineMAView *)klineMAView{
    if(!_klineMAView){
        _klineMAView = [[KM7KLineMAView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kLineMAHeight)];
    }
    return _klineMAView;
}

- (KM7VolumeMAView *)volumeMAView{
    
    if(!_volumeMAView){
        _volumeMAView = [[KM7VolumeMAView alloc] initWithFrame:CGRectMake(0, self.volumeLayer.frame.origin.y, self.frame.size.width, volumeMAHeight)];
    }
    return _volumeMAView;
}

- (CAShapeLayer *)klineLayer{
    if(!_klineLayer){
        _klineLayer = [CAShapeLayer layer];
        _klineLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * [KM7StockGlobalVariable kLineMainViewRadio]);
        _klineLayer.backgroundColor = [KM7StockGlobalVariable klineMainViewBgColor];
        
         //绘制网格 横竖各5个网格
        CGFloat width = _klineLayer.frame.size.width;
        CGFloat height = _klineLayer.frame.size.height;

        CGFloat unitW = width/horizontalGridCount;
        CGFloat unitH = (height - kLineMAHeight)/verticalGridCount;
        //用贝塞尔描路径
        UIBezierPath *cellPath = [UIBezierPath bezierPath];
        //横线
        for (int i = 0; i<=verticalGridCount; i++) {
            [cellPath moveToPoint:CGPointMake(0, i * unitH + kLineMAHeight)];
            [cellPath addLineToPoint:CGPointMake(width, i * unitH + kLineMAHeight)];        }
        //竖线
        for (int i = 1; i<=verticalGridCount; i++) {
            [cellPath moveToPoint:CGPointMake(i * unitW, 0)];
            [cellPath addLineToPoint:CGPointMake(i * unitW, height)];
        }
        _klineLayer.lineWidth = gridLineWidth;
        _klineLayer.strokeColor = [KM7StockGlobalVariable gridLineColor];
        _klineLayer.path = cellPath.CGPath;
    }
    return _klineLayer;
}


- (CAShapeLayer *)volumeLayer{
    if(!_volumeLayer){
        _volumeLayer = [CAShapeLayer layer];
        _volumeLayer.frame = CGRectMake(0,CGRectGetMaxY(self.klineLayer.frame), self.frame.size.width, self.frame.size.height - self.klineLayer.frame.size.height);
        _volumeLayer.backgroundColor = [KM7StockGlobalVariable klineVolumeViewBgColor];
        
        //绘制网格 横竖各5个网格
        CGFloat width = _volumeLayer.frame.size.width;
        CGFloat height = _volumeLayer.frame.size.height;
        
        CGFloat unitW = width/horizontalGridCount;
        //用贝塞尔描路径
        UIBezierPath *cellPath = [UIBezierPath bezierPath];
        //横线 volume区域的只需要画一根
        [cellPath moveToPoint:CGPointMake(0, 0)];
        [cellPath addLineToPoint:CGPointMake(width, 0)];
        //竖线
        for (int i = 1; i<=verticalGridCount; i++) {
            [cellPath moveToPoint:CGPointMake(i * unitW, 0)];
            [cellPath addLineToPoint:CGPointMake(i * unitW, height)];
        }
        _volumeLayer.lineWidth = gridLineWidth;
        _volumeLayer.strokeColor = [KM7StockGlobalVariable gridLineColor];
        _volumeLayer.path = cellPath.CGPath;
    }
    return _volumeLayer;
}

//制作Kline CAShapeLayer蜡烛图
- (CAShapeLayer *)getKlineShapeLayerFromModel:(KM7KLinePositionModel *)model{
    //生成layer 用贝塞尔路径给他渲染
    CAShapeLayer *shapLayer = [CAShapeLayer layer];
    shapLayer.frame = self.klineLayer.bounds;
    CGFloat kLineWidth = [KM7StockGlobalVariable kLineWidth];
    //用贝塞尔描路径
    // 绘制本体
    UIBezierPath *cellpath = [UIBezierPath bezierPathWithRect:CGRectMake(model.OpenPoint.x - kLineWidth/2, model.OpenPoint.y, kLineWidth, model.ClosePoint.y - model.OpenPoint.y)];
    //绘制影线
    [cellpath moveToPoint:model.HighPoint];
    [cellpath addLineToPoint:model.LowPoint];    
    shapLayer.fillColor = model.color;
    shapLayer.strokeColor = shapLayer.fillColor;
    shapLayer.path = cellpath.CGPath;
    //返回一个蜡烛图
    return shapLayer;
}
- (CAShapeLayer *)getVolumeShapeLayerFromModel:(KM7KLineVolumePosionModel *)model{
    //生成layer 用贝塞尔路径给他渲染
    CAShapeLayer *shapLayer = [CAShapeLayer layer];
    shapLayer.frame = self.volumeLayer.bounds;
    CGFloat kLineWidth = [KM7StockGlobalVariable kLineWidth];
    // 绘制本体
    UIBezierPath *cellpath = [UIBezierPath bezierPathWithRect:CGRectMake(model.StartPoint.x - kLineWidth/2, model.StartPoint.y, kLineWidth, model.EndPoint.y-model.StartPoint.y)];
    if(self.chartType == KM7KlineChartTypeKline){
        shapLayer.fillColor = model.color;
    }else{
        shapLayer.fillColor = [KM7StockGlobalVariable timelineVolColor];
    }
    
    shapLayer.strokeColor = shapLayer.fillColor;
    shapLayer.path = cellpath.CGPath;
    //返回一个蜡烛图
    return shapLayer;
}

#pragma mark - private

- (void)private_convertKLinePositionModels {
    if(!self.modelsArr.count)
    {
        return;
    }
    
    NSArray *kLineModels = self.modelsArr;
    //计算最小单位
    KM7KLineModel *firstModel = kLineModels.firstObject;
    __block double minAssert = firstModel.low;
    __block double maxAssert = firstModel.high;
    __block double minPrice = firstModel.low;
    __block double maxPrice = firstModel.high;
    __block NSUInteger minIndex = 0;
    __block NSUInteger maxIndex = 0;
    [kLineModels enumerateObjectsUsingBlock:^(KM7KLineModel * _Nonnull kLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if(kLineModel.high > maxPrice){
            maxPrice = kLineModel.high;
            maxIndex = idx;
        }
        if(kLineModel.low < minPrice){
            minPrice = kLineModel.low;
            minIndex= idx;
        }
        maxAssert = MAX(maxAssert, kLineModel.high);
        minAssert = MIN(minAssert, kLineModel.low);
        if(kLineModel.MA5)
        {
            maxAssert = MAX(maxAssert, kLineModel.MA5);
            minAssert = MIN(minAssert, kLineModel.MA5);
        }
        if(kLineModel.MA10)
        {
            maxAssert = MAX(maxAssert, kLineModel.MA10);
            minAssert = MIN(minAssert, kLineModel.MA10);
        }
        if(kLineModel.MA30)
        {
            maxAssert = MAX(maxAssert, kLineModel.MA30);
            minAssert = MIN(minAssert, kLineModel.MA30);
        }
    }];
//    KM7Log(@"minI˚ndex = %ld maxIndex=%ld", minIndex, maxIndex);
    CGFloat minY = kLineMAHeight + kLineTopRemainHeight;
    CGFloat maxY = self.klineLayer.frame.size.height - kLineBottomRemainHeight;
    CGFloat unitValue = (maxAssert - minAssert)/(maxY - minY);
    if(unitValue == 0){//maxAssert - minAssert=0的时候, 一般是数据有问题,做一下兼容
        unitValue = CGFLOAT_MAX;
    }
    self.klineUnitHeight = unitValue;
    NSInteger kLineModelsCount = kLineModels.count;
    self.KLinePositionModels = [NSMutableArray arrayWithCapacity:kLineModelsCount];
    self.MA5Positions = [NSMutableArray arrayWithCapacity:kLineModelsCount];
    self.MA10Positions = [NSMutableArray arrayWithCapacity:kLineModelsCount];
    self.MA30Positions = [NSMutableArray arrayWithCapacity:kLineModelsCount];
    self.MA60Positions = [NSMutableArray arrayWithCapacity:kLineModelsCount];
    self.highestPositionModel = nil;
    self.lowestestPositionModel = nil;
    for (NSInteger idx = 0 ; idx < kLineModelsCount; ++idx)
    {
        //K线坐标转换
        KM7KLineModel *kLineModel = kLineModels[idx];
        
        CGFloat xPosition = self.startXPosition + idx * ([KM7StockGlobalVariable kLineWidth] + [KM7StockGlobalVariable kLineGap]);
        CGPoint openPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.open - minAssert)/unitValue));
        CGFloat closePointY = ABS(maxY - (kLineModel.close - minAssert)/unitValue);
        // 当开盘价和收盘价差异很小的时候, 调整蜡烛高度
        if(ABS(closePointY - openPoint.y) < KM7StockChartKLineMinWidth)
        {
            if(openPoint.y > closePointY)
            {
                openPoint.y = closePointY + KM7StockChartKLineMinWidth;
            } else if(openPoint.y < closePointY)
            {
                closePointY = openPoint.y + KM7StockChartKLineMinWidth;
            } else {
                if(idx > 0)
                {
                    KM7KLineModel *preKLineModel = kLineModels[idx-1];
                    if(kLineModel.open > preKLineModel.close)
                    {
                        openPoint.y = closePointY + KM7StockChartKLineMinWidth;
                    } else {
                        closePointY = openPoint.y + KM7StockChartKLineMinWidth;
                    }
                } else if(idx+1 < kLineModelsCount){
                    
                    //idx==0即第一个时
                    KM7KLineModel *subKLineModel = kLineModels[idx+1];
                    if(kLineModel.close < subKLineModel.open)
                    {
                        openPoint.y = closePointY + KM7StockChartKLineMinWidth;
                    } else {
                        closePointY = openPoint.y + KM7StockChartKLineMinWidth;
                    }
                }
            }
        }
        
        CGPoint closePoint = CGPointMake(xPosition, closePointY);
        CGPoint highPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.high - minAssert)/unitValue));
        CGPoint lowPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.low - minAssert)/unitValue));
        CGColorRef color = openPoint.y > closePoint.y ? [KM7StockGlobalVariable klineIncreaseColor] : [KM7StockGlobalVariable klineDecreaseColor];
        KM7KLinePositionModel *kLinePositionModel = [KM7KLinePositionModel modelWithOpen:openPoint close:closePoint high:highPoint low:lowPoint color:color];
        if(idx == maxIndex){
            self.highestPositionModel = kLinePositionModel;
            self.highestPositionModel.high = kLineModel.high;
            self.highestPositionModel.assestHigh = maxAssert;
        }
        if(idx == minIndex){
            self.lowestestPositionModel = kLinePositionModel;
            self.lowestestPositionModel.low = kLineModel.low;
            self.lowestestPositionModel.assestLow = minAssert;
        }
//        kLinePositionModel.highest = idx == maxIndex;
//        kLinePositionModel.lowest = idx == minIndex;
        
        [self.KLinePositionModels addObject:kLinePositionModel];
        
        
        //MA坐标转换
        CGFloat ma5Y = maxY;
        CGFloat ma10Y = maxY;
        CGFloat ma30Y = maxY;
        CGFloat ma60Y = maxY;
        if(unitValue > 0.0000001)
        {
            if(kLineModel.MA5)
            {
                ma5Y = maxY - (kLineModel.MA5 - minAssert)/unitValue;
            }
            if(kLineModel.MA10)
            {
                ma10Y = maxY - (kLineModel.MA10 - minAssert)/unitValue;
            }
            if(kLineModel.MA30)
            {
                ma30Y = maxY - (kLineModel.MA30 - minAssert)/unitValue;
            }
            if(kLineModel.MA60)
            {
                ma60Y = maxY - (kLineModel.MA60 - minAssert)/unitValue;
            }
        }
        
        NSAssert(!isnan(ma5Y) && !isnan(ma10Y) && !isnan(ma30Y), @"出现NAN值");
        CGPoint ma5Point = CGPointMake(xPosition, ma5Y);
        CGPoint ma10Point = CGPointMake(xPosition, ma10Y);
        CGPoint ma30Point = CGPointMake(xPosition, ma30Y);
        CGPoint ma60Point = CGPointMake(xPosition, ma60Y);
        if(kLineModel.MA5)
        {
            [self.MA5Positions addObject: [NSValue valueWithCGPoint: ma5Point]];
        }
        if(kLineModel.MA10)
        {
            [self.MA10Positions addObject: [NSValue valueWithCGPoint: ma10Point]];
        }
        if(kLineModel.MA30)
        {
            [self.MA30Positions addObject: [NSValue valueWithCGPoint: ma30Point]];
        }
        if(kLineModel.MA60)
               {
                   [self.MA60Positions addObject: [NSValue valueWithCGPoint: ma60Point]];
               }
    }
}
- (void)private_convertVolumePositionModels{
    if(!self.modelsArr.count)
    {
        return;
    }
    CGFloat minY = volumeMAHeight + volumeTopRemainHeight;
    CGFloat maxY = self.volumeLayer.frame.size.height - volumeBottomRemainHeight;
    
    KM7KLineModel *firstModel = self.modelsArr.firstObject;
    __block CGFloat minVolume = firstModel.volume;
    __block CGFloat maxVolume = firstModel.volume;
    __block NSUInteger maxIndex = 0;// 需要保留最大volume或ma的idx
    [self.modelsArr enumerateObjectsUsingBlock:^(KM7KLineModel *  _Nonnull kLineModel, NSUInteger idx, BOOL * _Nonnull stop) {
        minVolume = MIN(minVolume, kLineModel.volume);
        if(kLineModel.volume > maxVolume){
            maxIndex = idx;
            maxVolume = kLineModel.volume;
        }
        if(kLineModel.Volume_MA5){
            minVolume = MIN(minVolume, kLineModel.Volume_MA5);
            maxVolume = MAX(maxVolume, kLineModel.Volume_MA5);
        }
        if(kLineModel.Volume_MA10){
            minVolume = MIN(minVolume, kLineModel.Volume_MA10);
            maxVolume = MAX(maxVolume, kLineModel.Volume_MA10);
        }
    }];
    
    CGFloat unitValue = (maxVolume - minVolume) / (maxY - minY);
    if(unitValue == 0){
        unitValue = CGFLOAT_MAX;
    }
    NSInteger kLineModelsCount = self.modelsArr.count;
    self.VolumePositionModels = [NSMutableArray arrayWithCapacity:kLineModelsCount];
    self.Volume_MA5Positions = [NSMutableArray arrayWithCapacity:kLineModelsCount];
    self.Volume_MA10Positions = [NSMutableArray arrayWithCapacity:kLineModelsCount];
    for(int i = 0; i<kLineModelsCount;++i){
        KM7KLinePositionModel *kLinePositionModel = self.KLinePositionModels[i];
        KM7KLineModel *klineModel = self.modelsArr[i];
        CGFloat xPosition = kLinePositionModel.HighPoint.x;
        CGFloat yPosition = ABS(maxY - (klineModel.volume - minVolume)/unitValue);
        CGPoint startPoint = CGPointMake(xPosition, yPosition);
        CGPoint endPoint = CGPointMake(xPosition, maxY);
        KM7KLineVolumePosionModel *volumePositionModel = [KM7KLineVolumePosionModel modelWithStartPoint:startPoint endPoint:endPoint color:kLinePositionModel.color];
        if(i == maxIndex){
            self.highestVolumePositionModel = volumePositionModel;
            self.highestVolumePositionModel.assestHigh = maxVolume;
        }
        [self.VolumePositionModels addObject:volumePositionModel];
        //MA坐标转换
        CGFloat ma5Y = maxY;
        CGFloat ma10Y = maxY;
        if(unitValue > 0.0000001){
            if(klineModel.Volume_MA5){
                ma5Y = maxY - (klineModel.Volume_MA5 - minVolume)/unitValue;
            }
            if(klineModel.Volume_MA10){
                ma10Y = maxY - (klineModel.Volume_MA10 - minVolume)/unitValue;
            }
        }
//        NSAssert(!isnan(ma5Y) && !isnan(ma10Y), @"出现NAN值");
        CGPoint ma5Point = CGPointMake(xPosition, ma5Y);
        CGPoint ma10Point = CGPointMake(xPosition, ma10Y);
        if(klineModel.Volume_MA5){
            [self.Volume_MA5Positions addObject: [NSValue valueWithCGPoint: ma5Point]];
        }
        if(klineModel.Volume_MA10){
            [self.Volume_MA10Positions addObject: [NSValue valueWithCGPoint: ma10Point]];
        }
    }
}

// 生成MA线layer
-(CAShapeLayer *)private_generateMaLayerWithFrame:(CGRect)frame andPositions:(NSArray *)positions andLineColor:(CGColorRef)lineColor{
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.frame = frame;
     UIBezierPath *MAPath = [UIBezierPath bezierPath];
    [positions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx == 0){
            [MAPath moveToPoint:[obj CGPointValue]];
        }else{
            [MAPath addLineToPoint:[obj CGPointValue]];
        }
    }];
    shaperLayer.fillColor = [UIColor clearColor].CGColor;
    shaperLayer.strokeColor = lineColor;
    shaperLayer.path = MAPath.CGPath;
    return shaperLayer;
}

// 生成k线图辅助layer 包括:1.最高点(最低点) 2.右侧price
-(CAShapeLayer *)private_generateKlineAssistLayer{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.klineLayer.bounds;
    
    if(self.chartType == KM7KlineChartTypeKline){
        // ============ 绘制最高点和最低点 ===============
        UIBezierPath *path = [UIBezierPath bezierPath];
        // 1.最高点
        CGPoint highPoint = self.highestPositionModel.HighPoint;
        [path moveToPoint:highPoint];
        // 最高点文字
//        NSString km7_market_getFormatPrice:<#(CGFloat)#> basePrice:<#(CGFloat)#>
        CATextLayer *highTextLayer = [self getTextLayerByText:[NSString km7_market_getFormatPrice:self.highestPositionModel.high basePrice:self.highestPositionModel.high] andFont:[UIFont systemFontOfSize:12] andColor:[KM7StockGlobalVariable klineHighLowAssistColor]];
        CGRect highFrame = highTextLayer.frame;
        if(highPoint.x > shapeLayer.frame.size.width/2){
            [path addLineToPoint:CGPointMake(highPoint.x - 20, highPoint.y)];
            highFrame.origin = CGPointMake(highPoint.x - 20 - highFrame.size.width, highPoint.y - highFrame.size.height/2);
        }else{
            [path addLineToPoint:CGPointMake(highPoint.x + 20, highPoint.y)];
            highFrame.origin = CGPointMake(highPoint.x+20, highPoint.y - highFrame.size.height/2);
        }
        highTextLayer.frame = highFrame;
        [shapeLayer addSublayer:highTextLayer];
        // 2.最低点
        CGPoint lowPoint = self.lowestestPositionModel.LowPoint;
        [path moveToPoint:lowPoint];
        // 最低点文字
        CATextLayer *lowTextLayer = [self getTextLayerByText:[NSString km7_market_getFormatPrice:self.lowestestPositionModel.low basePrice:self.lowestestPositionModel.low] andFont:[UIFont systemFontOfSize:12] andColor:[KM7StockGlobalVariable klineHighLowAssistColor]];
        CGRect lowFrame = lowTextLayer.frame;
        if(lowPoint.x > shapeLayer.frame.size.width/2){
            [path addLineToPoint:CGPointMake(lowPoint.x - 20, lowPoint.y)];
            lowFrame.origin = CGPointMake(lowPoint.x - 20 - lowFrame.size.width, lowPoint.y - lowFrame.size.height/2);
        }else{
            [path addLineToPoint:CGPointMake(lowPoint.x + 20, lowPoint.y)];
            lowFrame.origin = CGPointMake(lowPoint.x + 20, lowPoint.y - lowFrame.size.height/2);
        }
        lowTextLayer.frame = lowFrame;
        [shapeLayer addSublayer:lowTextLayer];
        shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        shapeLayer.path = path.CGPath;
    }
    
    
    // ============ 绘制右侧价格文字 ===============
    //根据网格坐标, 确定文字显示位置
    CGFloat height = self.klineLayer.frame.size.height;
    CGFloat width = self.klineLayer.frame.size.width;
    CGFloat unitH = (height - kLineMAHeight)/verticalGridCount;
    CGFloat unitPrice = (self.highestPositionModel.assestHigh - self.lowestestPositionModel.assestLow)/verticalGridCount;//每个网格代表的价格
    //文字
    for (int i = 0; i<=verticalGridCount; i++) {
        CGFloat price = self.highestPositionModel.assestHigh - i*unitPrice;
        if(i == verticalGridCount){
            price = self.lowestestPositionModel.assestLow;
        }
        CATextLayer *textLayer = [self getTextLayerByText:[NSString km7_market_getFormatPrice:price basePrice:price] andFont:[UIFont systemFontOfSize:12] andColor:[KM7StockGlobalVariable klinePriceAssistColor]];
        CGRect frame = textLayer.frame;
        if(i == 0){
            frame.origin = CGPointMake(width-frame.size.width, i * unitH + kLineMAHeight);
        }else{
            frame.origin = CGPointMake(width-frame.size.width, i * unitH + kLineMAHeight - frame.size.height);
        }
        textLayer.frame = frame;
        
        [shapeLayer addSublayer:textLayer];
    }
    return shapeLayer;
}


// 生成volume成交量的辅助layer
-(CAShapeLayer *)private_generateVolumeAssistLayer{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.volumeLayer.bounds;
    CGFloat width = self.volumeLayer.frame.size.width;
    CGFloat height = self.volumeLayer.frame.size.height;
    //1. 右侧坐标
    CATextLayer *textLayer = [self getTextLayerByText:self.highestVolumePositionModel.assestHigh_format andFont:[UIFont systemFontOfSize:12] andColor:[KM7StockGlobalVariable klinePriceAssistColor]];
    CGRect frame = textLayer.frame;
    frame.origin = CGPointMake(width - frame.size.width, (volumeMAHeight - frame.size.height)/2);
    textLayer.frame = frame;
    [shapeLayer addSublayer:textLayer];
    
    //2. 底部时间
    CGFloat unitW = width/horizontalGridCount;
    for (int i = 0; i<=horizontalGridCount; i++) {
        NSUInteger index = i*unitW/([KM7StockGlobalVariable kLineWidth] + [KM7StockGlobalVariable kLineGap]);
        if(index >= self.modelsArr.count) break;
        KM7KLineModel *model = self.modelsArr[index];
         CATextLayer *textLayer = [self getTextLayerByText:model.time_format andFont:[UIFont systemFontOfSize:10] andColor:[KM7StockGlobalVariable klineTimeColor]];
        CGRect frame = textLayer.frame;
        frame.origin = CGPointMake(i*unitW - frame.size.width/2, height - volumeBottomRemainHeight + (volumeBottomRemainHeight - frame.size.height)/2);
        textLayer.frame = frame;
        [shapeLayer addSublayer:textLayer];
    }
    
    
    return shapeLayer;
}

-(void)private_reloadKlineLayer{
    [self.klineLayer removeFromSuperlayer];
    _klineLayer = nil;
//    [self.layer addSublayer:self.klineLayer];
    [self.layer insertSublayer:self.klineLayer below:self.volumeMAView.layer];
    if(self.chartType == KM7KlineChartTypeKline){
        //1. 绘制蜡烛
        [self.KLinePositionModels enumerateObjectsUsingBlock:^(KM7KLinePositionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CAShapeLayer *shapeLayer = [self getKlineShapeLayerFromModel:obj];
            [self.klineLayer addSublayer: shapeLayer];
        }];
        //2. 绘制MA线
        [self.klineLayer addSublayer: [self private_generateMaLayerWithFrame:self.klineLayer.bounds andPositions:self.MA5Positions andLineColor:[KM7StockGlobalVariable MA5Color]]];
        [self.klineLayer addSublayer: [self private_generateMaLayerWithFrame:self.klineLayer.bounds andPositions:self.MA10Positions andLineColor:[KM7StockGlobalVariable MA10Color]]];
        [self.klineLayer addSublayer: [self private_generateMaLayerWithFrame:self.klineLayer.bounds andPositions:self.MA30Positions andLineColor:[KM7StockGlobalVariable MA30Color]]];
        [self.klineLayer addSublayer: [self private_generateMaLayerWithFrame:self.klineLayer.bounds andPositions:self.MA60Positions andLineColor:[KM7StockGlobalVariable MA60Color]]];
    }else{
        //1. 以收盘价绘制分时线
        UIBezierPath *maskPath = [UIBezierPath bezierPath];
        UIBezierPath *strokePath = [UIBezierPath bezierPath];
        CGFloat maxY = self.klineLayer.bounds.size.height - kLineBottomRemainHeight;
        [self.KLinePositionModels enumerateObjectsUsingBlock:^(KM7KLinePositionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(idx == 0){
                [maskPath moveToPoint:CGPointMake(obj.ClosePoint.x, maxY)];
                [strokePath moveToPoint:obj.ClosePoint];
            }else{
                [strokePath addLineToPoint:obj.ClosePoint];
            }
            [maskPath addLineToPoint:obj.ClosePoint];
            if(idx == self.KLinePositionModels.count - 1){
                [maskPath addLineToPoint:CGPointMake(obj.ClosePoint.x, maxY)];
            }
        }];
       
//        [path closePath];
        CAShapeLayer *timeLineLayer = [CAShapeLayer layer];
        timeLineLayer.frame = self.klineLayer.bounds;
        timeLineLayer.path = strokePath.CGPath;
        timeLineLayer.lineWidth =1;
        timeLineLayer.strokeColor = [KM7StockGlobalVariable timelineVolColor];
        timeLineLayer.fillColor = [UIColor clearColor].CGColor;
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = self.klineLayer.bounds;
        maskLayer.path = maskPath.CGPath;
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = timeLineLayer.bounds;
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1);
        CGColorRef color1 = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.38].CGColor;
        CGColorRef color2 = [UIColor colorWithRed:255 green:255 blue:255 alpha:0].CGColor;
        gradientLayer.colors = @[(__bridge id)color1,(__bridge id)color2];
        gradientLayer.locations = @[@0,@0.9];
        gradientLayer.mask = maskLayer;
        
        [timeLineLayer addSublayer:gradientLayer];
        [self.klineLayer addSublayer:timeLineLayer];
    }
    
  
    //3. 绘制辅助点(最高点,最低点,右侧坐标)
    [self.klineLayer addSublayer:[self private_generateKlineAssistLayer]];
    
}

- (void)private_reloadLatestLayer{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.klineLayer.bounds;
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointMake(self.klineLayer.frame.size.width, startPoint.y);
    CATextLayer *textLayer = [self getTextLayerByText:self.latestModel.close_format andFont:[UIFont systemFontOfSize:10] andColor:[UIColor whiteColor].CGColor];
    CGRect frame = textLayer.frame;
    // 计算y轴坐标 调整textLayer样式
    NSUInteger idx = [self.modelsArr indexOfObject:self.latestModel];
    if(idx != NSNotFound && self.KLinePositionModels[idx].ClosePoint.x < shapeLayer.frame.size.width - 50){// 最新点在显示范围内
        startPoint.x = self.KLinePositionModels[idx].ClosePoint.x;
        startPoint.y = self.KLinePositionModels[idx].ClosePoint.y;
    }else{// 不在显示范围内
        startPoint.x = 0;
        if(self.latestModel.close < self.lowestestPositionModel.assestLow){
            startPoint.y = self.klineLayer.frame.size.height - kLineBottomRemainHeight;
        }else if(self.latestModel.close > self.highestPositionModel.assestHigh){
            startPoint.y = kLineMAHeight + kLineTopRemainHeight;
        }else{
            startPoint.y = self.klineLayer.frame.size.height - kLineBottomRemainHeight - (self.latestModel.close - self.lowestestPositionModel.assestLow)/self.klineUnitHeight;
        }
    }
    frame.origin = CGPointMake(self.klineLayer.frame.size.width - frame.size.width, startPoint.y - frame.size.height/2);
    endPoint.x = frame.origin.x;
    endPoint.y = startPoint.y;
    textLayer.frame = frame;
    [shapeLayer addSublayer:textLayer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    shapeLayer.lineDashPattern = @[@5,@5];
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.path = path.CGPath;
    shapeLayer.lineWidth = 1/[UIScreen mainScreen].scale;
    [self.klineLayer addSublayer:shapeLayer];
}

- (CATextLayer *)getTextLayerByText:(NSString *)text andFont:(UIFont *)font andColor:(CGColorRef)color{
    CATextLayer *textLayer = [CATextLayer layer];
     textLayer.contentsScale = [UIScreen mainScreen].scale;
    CGSize size = [NSString km7_getTextWidtText:text font:font];
    textLayer.frame = CGRectMake(0, 0, size.width, size.height);
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.wrapped = YES;
    textLayer.foregroundColor = color;
    //set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    //set layer text
    textLayer.string = text;
   
    return textLayer;
}

-(void)private_reloadVolumeLayer{
    [self.volumeLayer removeFromSuperlayer];
    _volumeLayer = nil;
    [self.layer insertSublayer:self.volumeLayer below:self.volumeMAView.layer];
     //1. 绘制蜡烛
    [self.VolumePositionModels enumerateObjectsUsingBlock:^(KM7KLineVolumePosionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CAShapeLayer *shapeLayer = [self getVolumeShapeLayerFromModel:obj];
        [self.volumeLayer addSublayer: shapeLayer];
    }];
    
    if(self.chartType == KM7KlineChartTypeKline){
        //2. 绘制Ma线
        [self.volumeLayer addSublayer: [self private_generateMaLayerWithFrame:self.klineLayer.bounds andPositions:self.Volume_MA5Positions andLineColor:[KM7StockGlobalVariable MA5Color]]];
        [self.volumeLayer addSublayer: [self private_generateMaLayerWithFrame:self.klineLayer.bounds andPositions:self.Volume_MA10Positions andLineColor:[KM7StockGlobalVariable MA10Color]]];
    }
    //3. 绘制辅助点(右侧坐标)
    [self.volumeLayer addSublayer:[self private_generateVolumeAssistLayer]];
}

-(void)private_showDetailViewWithModelIndex:(NSUInteger)index{
    KM7KLineModel *klineModel = self.modelsArr[index];
    KM7KLinePositionModel *klinePositionModel = self.KLinePositionModels[index];
    [self.detailView reloadWithModel:klineModel andCrossPoint:klinePositionModel.ClosePoint];
    self.klineMAView.model = klineModel;
    self.volumeMAView.model = klineModel;
}
- (void)private_hideDetailView{
    self.detailView.hidden = YES;
    self.klineMAView.model = self.latestModel;
    self.volumeMAView.model = self.latestModel;
}

#pragma mark - extern methods
- (void)reloadWithModels:(NSArray<KM7KLineModel *> *)models latestModel:(KM7KLineModel *)latestModel{
    
    self.modelsArr = models;
    //MA指标label
    if(self.latestModel != latestModel){
        self.latestModel = latestModel;
        self.klineMAView.model = latestModel;
        self.volumeMAView.model = latestModel;
    }
    
    //k线图
    [self private_convertKLinePositionModels];
    [self private_reloadKlineLayer];
   
    //volume成交量
    [self private_convertVolumePositionModels];
    [self private_reloadVolumeLayer];
    
    
    //最新价
    [self private_reloadLatestLayer];
    
    
    if(!self.detailView.hidden){
        [self private_hideDetailView];
    }
}
@end
