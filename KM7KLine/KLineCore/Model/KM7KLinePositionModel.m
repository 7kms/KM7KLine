

//
//  KM7KLinePositionModel.m
//  Stark
//
//  Created by tangl on 2019/8/9.
//  Copyright © 2019 km7. All rights reserved.
//

#import "KM7KLinePositionModel.h"

@implementation KM7KLinePositionModel


+ (instancetype) modelWithOpen:(CGPoint)openPoint close:(CGPoint)closePoint high:(CGPoint)highPoint low:(CGPoint)lowPoint color:(nonnull CGColorRef)color
{
    KM7KLinePositionModel *model = [KM7KLinePositionModel new];
    model.OpenPoint = openPoint;
    model.ClosePoint = closePoint;
    model.HighPoint = highPoint;
    model.LowPoint = lowPoint;
    model.color = color;
    return model;
}

@end
