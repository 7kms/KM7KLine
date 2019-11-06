//
//  KM7KLineVolumePosionModel.m
//  Stark
//
//  Created by tangl on 2019/8/9.
//  Copyright © 2019 km7. All rights reserved.
//

#import "KM7KLineVolumePosionModel.h"
#import "NSString+KM7Extention.h"

@implementation KM7KLineVolumePosionModel

+ (instancetype) modelWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint color:(nonnull CGColorRef)color
{
    KM7KLineVolumePosionModel *volumePositionModel = [KM7KLineVolumePosionModel new];
    volumePositionModel.StartPoint = startPoint;
    volumePositionModel.EndPoint = endPoint;
    volumePositionModel.color = color;
    return volumePositionModel;
}

- (NSString *)assestHigh_format{
    if(!_assestHigh_format){
        _assestHigh_format = [NSString km7_market_getFormatVolume:self.assestHigh];
    }
    return _assestHigh_format;
}

@end
