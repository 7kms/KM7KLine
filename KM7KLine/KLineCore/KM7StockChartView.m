
//
//  KM7StockChartView.m
//  Stark
//
//  Created by tangl on 2019/8/9.
//  Copyright © 2019 km7. All rights reserved.
//

#import "KM7StockChartView.h"
#import "KM7KLineView.h"
#import "KM7StockConstant.h"
#import "KM7KLineModelManeger.h"
#import "KM7KLinePositionModel.h"
#import "UILabel+KM7Extention.h"
#import "UIView+KM7Extention.h"


static BOOL isNeedPostNotification = YES;

@interface KM7StockChartView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) KM7KLineView *contentView;
@property (nonatomic, strong) KM7KLineModelManeger *modelManager;
@property (nonatomic, strong) NSMutableArray<KM7KLineModel *> *showModlesArr; //需要绘制的模型数组
@property (nonatomic, assign) CGFloat oldContentOffsetX;
@property (nonatomic, assign) CGFloat oldScrollOffsetRight; //scrollview距离最右边的准确位置
@property (nonatomic, assign) NSInteger pinchStartIndex; // 缩放之后重新绘制起始index
@property (nonatomic, assign) NSInteger needDrawStartIndex; // 开始绘制的index



@end
@implementation KM7StockChartView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.contentView];
        [self addSubview:self.loadingView];
        NSLog(@"%@", NSStringFromCGRect(self.frame));
    }
    return self;
}

#pragma mark - getter

- (NSInteger)needDrawStartIndex{
    CGFloat scrollViewOffsetX = MAX(self.scrollView.contentOffset.x, 0);
    NSUInteger leftArrCount = scrollViewOffsetX / ([KM7StockGlobalVariable kLineGap] + [KM7StockGlobalVariable kLineWidth]);
    _needDrawStartIndex = leftArrCount;
    return _needDrawStartIndex;
}

#pragma mark - lazy

- (NSMutableArray<KM7KLineModel *> *)showModlesArr{
    if(!_showModlesArr){
        _showModlesArr = [NSMutableArray new];
    }
    return _showModlesArr;
}

- (KM7KLineModelManeger *)modelManager{
    if(!_modelManager){
        _modelManager = [KM7KLineModelManeger new];
    }
    return _modelManager;
}
- (KM7KLineView *)contentView{
    if(!_contentView){
        _contentView = [[KM7KLineView alloc] initWithFrame:self.scrollView.bounds];
        _contentView.backgroundColor = [UIColor blueColor];
    }
    return _contentView;
}

- (UIActivityIndicatorView *)loadingView{
    if(!_loadingView){
        _loadingView = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
        _loadingView.color = [UIColor whiteColor];
//        _loadingView.userInteractionEnabled = NO;
        [_loadingView startAnimating];
    }
    return _loadingView;
}
- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _scrollView.contentSize = CGSizeMake(1000, self.size_height);
        //缩放手势
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(event_pichMethod:)];
        [_scrollView addGestureRecognizer:pinchGesture];
    }
    return _scrollView;
}

#pragma mark - 缩放执行方法
- (void)event_pichMethod:(UIPinchGestureRecognizer *)pinch
{
    static CGFloat oldScale = 1.0f;
    CGFloat difValue = pinch.scale - oldScale;
    if(ABS(difValue) > KM7StockChartScaleBound) {
        CGFloat oldKLineWidth = [KM7StockGlobalVariable kLineWidth];
        if (oldKLineWidth == KM7StockChartKLineMinWidth && difValue <= 0){
            return;
        }
        NSInteger oldNeedDrawStartIndex = self.needDrawStartIndex;
        
        [KM7StockGlobalVariable setkLineWith:oldKLineWidth * (difValue > 0 ? (1 + KM7StockChartScaleFactor) : (1 - KM7StockChartScaleFactor))];
        oldScale = pinch.scale;
        
        if( pinch.numberOfTouches == 2 ) {
            CGPoint p1 = [pinch locationOfTouch:0 inView:self.scrollView];
            CGPoint p2 = [pinch locationOfTouch:1 inView:self.scrollView];
            CGPoint centerPoint = CGPointMake((p1.x+p2.x)/2, (p1.y+p2.y)/2);
            NSUInteger oldLeftArrCount = ABS(centerPoint.x - self.scrollView.contentOffset.x) / ([KM7StockGlobalVariable kLineGap] + oldKLineWidth);
            NSUInteger newLeftArrCount = ABS(centerPoint.x - self.scrollView.contentOffset.x) / ([KM7StockGlobalVariable kLineGap] + [KM7StockGlobalVariable kLineWidth]);
            self.pinchStartIndex = oldNeedDrawStartIndex + oldLeftArrCount - newLeftArrCount;
            _needDrawStartIndex = self.pinchStartIndex;
        }
    }
    
    [self updateMainViewWidth];
    
    [self drawMainView];
}

//更新Scrollview的contentsize
- (void)updateMainViewWidth{
    //根据stockModels的个数和间隔和K线的宽度计算出self的宽度，并设置contentsize
    CGFloat scrollViewFrameWidth = self.scrollView.size_width;
    CGFloat kLineViewWidth = self.modelManager.modelsArr.count * ([KM7StockGlobalVariable kLineWidth] + [KM7StockGlobalVariable kLineGap]) + self.scrollView.frame.size.width/horizontalGridCount;//多加一个grid的宽度, 为右边坐标显示留出空间
    if(kLineViewWidth < scrollViewFrameWidth) {
        kLineViewWidth = scrollViewFrameWidth;
    }
    //更新scrollview的contentsize
    self.scrollView.contentSize = CGSizeMake(kLineViewWidth, self.scrollView.contentSize.height);
    
    
    
    CGFloat offset = kLineViewWidth - scrollViewFrameWidth;
    if (self.pinchStartIndex > 0){
        //缩放
        CGFloat new_x = self.pinchStartIndex * ([KM7StockGlobalVariable kLineGap] + [KM7StockGlobalVariable kLineWidth]);
        self.scrollView.contentOffset = CGPointMake(new_x, 0);
        self.pinchStartIndex = -1;
    }else{
        if (offset > 0){
            if(self.oldScrollOffsetRight){// 如果是加载更多 进来的数据,scrollView.contentOffset要设置到加载之前的位置, 保证体验连贯
                self.scrollView.contentOffset = CGPointMake(kLineViewWidth - self.oldScrollOffsetRight, 0);
            }else{
                self.scrollView.contentOffset = CGPointMake(offset, 0);
            }
        } else {
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }
    }
}
- (void)drawMainView{
    if(self.modelManager.modelsArr.count < 1){
        return;
    }
    //提取需要的kLineModel
    [self private_extractNeedDrawModels];
    [self.contentView reloadWithModels:self.showModlesArr latestModel:self.modelManager.modelsArr.lastObject];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat contentWidth = scrollView.contentSize.width;
    if(offsetX < 0){
        self.contentView.startXoffset = -offsetX;
    }else{
       self.contentView.startXoffset = 0;
    }
    self.contentView.origin_x = scrollView.contentOffset.x;
    self.oldScrollOffsetRight = contentWidth - offsetX;
    if(offsetX < scrollView.size_width){
        if(isNeedPostNotification){
            isNeedPostNotification = NO;
            if(self.loadMoreNoticeBlock){
                self.loadMoreNoticeBlock();
            }
        }
    }
    CGFloat difValue = ABS(offsetX - self.oldContentOffsetX);
    if(difValue >= [KM7StockGlobalVariable kLineGap] + [KM7StockGlobalVariable kLineWidth]){
        self.oldContentOffsetX = offsetX;
        [self drawMainView];
    }
}

#pragma mark 私有方法

//提取需要绘制的数组
- (NSArray *)private_extractNeedDrawModels{
    CGFloat lineGap = [KM7StockGlobalVariable kLineGap];
    CGFloat lineWidth = [KM7StockGlobalVariable kLineWidth];
    
    //数组个数
    CGFloat scrollViewWidth = self.scrollView.frame.size.width;
    NSInteger needDrawKLineCount = scrollViewWidth/(lineGap+lineWidth);
    
    //起始位置
    NSInteger needDrawKLineStartIndex = self.needDrawStartIndex;;
    
    //    NSLog(@"这是模型开始的index-----------%lu",needDrawKLineStartIndex);
    [self.showModlesArr removeAllObjects];
    
    //赋值数组
    if(needDrawKLineStartIndex < self.modelManager.modelsArr.count)
    {
        if(needDrawKLineStartIndex + needDrawKLineCount < self.modelManager.modelsArr.count)
        {
            [self.showModlesArr addObjectsFromArray:[self.modelManager.modelsArr subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, needDrawKLineCount+1)]];
        } else{
            [self.showModlesArr addObjectsFromArray:[self.modelManager.modelsArr subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, self.modelManager.modelsArr.count - needDrawKLineStartIndex)]];
        }
    }
    return self.showModlesArr;
}


#pragma mark - extern methods

- (void)reloadDataWithModlesArr:(NSArray<NSDictionary *> *)dataArr klineType:(KM7KlineChartType)klinetype andDateType:(KM7KlineDateType)dateType{
    [self changeLoadingStatus:NO];
    isNeedPostNotification = YES;
    self.contentView.chartType = klinetype;
    self.oldScrollOffsetRight = 0;
    self.modelManager.dateType = dateType;
    [self.modelManager refreshModelsArr:dataArr];
    [self updateMainViewWidth];
    [self drawMainView];
}

- (void)prependDataWithModlesArr:(NSArray<NSDictionary *> *)dataArr klineType:(KM7KlineChartType)klinetype andDateType:(KM7KlineDateType)dateType{
    [self changeLoadingStatus:NO];
    NSAssert(self.modelManager.dateType == dateType, @"k线时间类型不一致");
    isNeedPostNotification = YES;
    self.contentView.chartType = klinetype;
    self.modelManager.dateType = dateType;
    [self.modelManager prependModelsArr:dataArr];
    [self updateMainViewWidth];
    [self drawMainView];
}
- (void)appendDataWithModlesArr:(NSArray<NSDictionary *> *)dataArr klineType:(KM7KlineChartType)klinetype andDateType:(KM7KlineDateType)dateType{
    if(self.modelManager.dateType != dateType){ // 如果外界数据源注入没控制好,会导致k线时间类型不一致.所以忽略掉本次调用
        return;
    }
    if([self.modelManager appendModelsArr:dataArr]){//去重并添加
        isNeedPostNotification = YES;
        [self updateMainViewWidth];
        [self drawMainView];
    }
   
}
- (void)refreshLatestData:(NSDictionary *)dict{
    
}

- (void)changeLoadingStatus:(BOOL)loading{
    if(loading){
        self.loadingView.hidden = NO;
        [self.loadingView startAnimating];
    }else{
        [self.loadingView stopAnimating];
        self.loadingView.hidden = YES;
    }
}

@end
