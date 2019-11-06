
//
//  KM7KLineModelManeger.m
//  Stark
//
//  Created by tangl on 2019/8/9.
//  Copyright © 2019 km7. All rights reserved.
//

#import "KM7KLineModelManeger.h"
#import "KM7KLineModel.h"

typedef struct {
    CGFloat MA;
    CGFloat Volume_MA;
} MaAndVolume;

@implementation KM7KLineModelManeger
@synthesize modelsArr = _modelsArr;


- (NSMutableArray<KM7KLineModel *> *)modelsArr{
    if(!_modelsArr){
        _modelsArr = [NSMutableArray array];
    }
    return _modelsArr;
}

- (MaAndVolume)getMaAndVolumeWithModel:(KM7KLineModel *)obj idx:(NSInteger)idx andMacount:(NSInteger)macount{
    CGFloat ma= 0, volume_ma= 0;
    if(idx == macount - 1){
        ma = obj.SumOfLastClose/macount;
        volume_ma = obj.SumOfLastVolume/macount;
    }else{
        ma = (obj.SumOfLastClose - _modelsArr[idx - macount].SumOfLastClose)/macount;
        volume_ma = (obj.SumOfLastVolume - _modelsArr[idx - macount].SumOfLastVolume)/macount;
    }
    return (MaAndVolume){
        ma,volume_ma
    };
    
}

- (void)caculateMALine{
    [_modelsArr enumerateObjectsUsingBlock:^(KM7KLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(idx == 0){
            obj.SumOfLastClose = obj.close;
            obj.SumOfLastVolume = obj.volume;
        }else{
            obj.SumOfLastClose = obj.close + self.modelsArr[idx - 1].SumOfLastClose;
            obj.SumOfLastVolume = obj.volume + self.modelsArr[idx - 1].SumOfLastVolume;
        }
        // MA5
        if(idx >= 4){
            MaAndVolume ma5volume = [self getMaAndVolumeWithModel:obj idx:idx andMacount:5];
            obj.MA5 = ma5volume.MA;
            obj.Volume_MA5 = ma5volume.Volume_MA;
        }
        // MA10
        if(idx >= 9){
            MaAndVolume ma10volume = [self getMaAndVolumeWithModel:obj idx:idx andMacount:10];
            obj.MA10 = ma10volume.MA;
            obj.Volume_MA10 = ma10volume.Volume_MA;
        }
        // MA30
        if(idx >= 29){
            MaAndVolume ma30volume = [self getMaAndVolumeWithModel:obj idx:idx andMacount:30];
            obj.MA30 = ma30volume.MA;
            obj.Volume_MA30 = ma30volume.Volume_MA;
        }
        // MA60
        if(idx >= 59){
            MaAndVolume ma60volume = [self getMaAndVolumeWithModel:obj idx:idx andMacount:60];
            obj.MA60 = ma60volume.MA;
//            obj.Volume_MA30 = ma30volume.Volume_MA;
        }
    }];
}

- (NSMutableArray<KM7KLineModel *> * _Nonnull)getModelsWithArr:(NSArray <NSDictionary *> *)arr{
    NSMutableArray<KM7KLineModel *> *modelsArr = [NSMutableArray arrayWithCapacity:arr.count];
    [arr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        KM7KLineModel *model = [KM7KLineModel modelWithDict:obj andType: self.dateType];
        [modelsArr addObject:model];
    }];
    return modelsArr;
}

- (void)prependModelsArr:(NSArray<NSDictionary *> *)arr{
    if(arr.count < 1){
        return;
    }
    NSMutableArray<KM7KLineModel *> *newArr = [self getModelsWithArr:arr];
    [newArr addObjectsFromArray:self.modelsArr];
    _modelsArr = newArr;
    [self caculateMALine];
}

- (BOOL)appendModelsArr:(NSArray<NSDictionary *> *)arr{
    if(arr.count < 1){
        return NO;
    }
    NSMutableArray<KM7KLineModel *> *newArr = [self getModelsWithArr:arr];
    if(newArr.count == 0){
        [self prependModelsArr:arr];
        return NO;
    }
    KM7KLineModel *lastModel = [self.modelsArr lastObject];
    __block NSUInteger targetIndex = -1;
    [newArr enumerateObjectsUsingBlock:^(KM7KLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.timestamp == lastModel.timestamp){
            targetIndex = idx;
        }
    }];
    if(targetIndex == -1){
        return NO;
    }
    NSArray *finallyArr = [newArr subarrayWithRange:NSMakeRange(targetIndex, newArr.count - targetIndex)];
    [_modelsArr removeObject:lastModel];
    [_modelsArr addObjectsFromArray:finallyArr];
    [self caculateMALine];
    return YES;
}

- (void)refreshModelsArr:(NSArray<NSDictionary *> *)arr{
     NSMutableArray *newArr = [self getModelsWithArr:arr];
     _modelsArr = newArr;
    [self caculateMALine];
}

@end
