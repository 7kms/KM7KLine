//
//  KM7KLineModel.m
//  Stark
//
//  Created by tangl on 2019/8/9.
//  Copyright © 2019 km7. All rights reserved.
//

#import "KM7KLineModel.h"
#import "NSString+KM7Extention.h"

@implementation KM7KLineModel


/*
 {
 "timestamp": 1548201600,
 "open": 3570.93,
 "close": 3552.82,
 "low": 3514.5,
 "high": 3607.98,
 "volume_from": 23071.74,
 "volume_to": 82165371.55
 }
 */
- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        self.high = [dict[@"high"] floatValue];
        self.low = [dict[@"low"] floatValue];
        self.open = [dict[@"open"] floatValue];
        self.close = [dict[@"close"] floatValue];
        self.volume = [dict[@"amount"] floatValue];
        self.timestamp = [dict[@"id"] integerValue];
    }
    return self;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict andType: (KM7KlineDateType)dateType{
    KM7KLineModel *model = [[self alloc] initWithDict:dict];
    model.dateType = dateType;
    return model;
}


- (NSString *)time_format{
    if(!_time_format){
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.timestamp];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        switch (self.dateType) {
            case KM7KlineDateTypeMin:
            case KM7KlineDateType15Min:
            case KM7KlineDateTypeHour:
            case KM7KlineDateType4Hour:
                formatter.dateFormat = @"MM-dd HH:mm";
                break;
            case KM7KlineDateTypeDay:
            case KM7KlineDateTypeWeek:
                formatter.dateFormat = @"yy-MM-dd";
                break;
                case KM7KlineDateTypeMonth:
                formatter.dateFormat = @"yy-MM";
                break;
            default:
                formatter.dateFormat = @"MM-dd HH:mm";
                break;
        }
         _time_format = [formatter stringFromDate:date];
    }
    return _time_format;
}



- (NSString *)open_format{
    if(!_open_format){
        _open_format = [NSString km7_market_getFormatPrice:self.open basePrice:self.high];
    }
    return _open_format;
}

- (NSString *)close_format{
    if(!_close_format){
        _close_format = [NSString km7_market_getFormatPrice:self.close basePrice:self.high];
    }
    return _close_format;
}
- (NSString *)high_format{
    if(!_high_format){
        _high_format = [NSString km7_market_getFormatPrice:self.high basePrice:self.high];
    }
    return _high_format;
}
- (NSString *)low_format{
    if(!_low_format){
        _low_format = [NSString km7_market_getFormatPrice:self.low basePrice:self.high];
    }
    return _low_format;
}
- (NSString *)volume_format{
    if(!_volume_format){
        _volume_format = [NSString km7_market_getFormatVolume:self.volume];
    }
    return _volume_format;
}

- (NSString *)change_format{
    if(!_change_format){
        CGFloat change = (self.close - self.open)/self.open * 100;
        _change_format = [NSString stringWithFormat:@"%.2f%%", change];
    }
    return _change_format;
}

- (NSString *)MA5_format{
    return [NSString km7_market_getFormatPrice:self.MA5 basePrice:self.high];
}

- (NSString *)MA10_format{
    return [NSString km7_market_getFormatPrice:self.MA10 basePrice:self.high];
}

- (NSString *)MA30_format{
    return [NSString km7_market_getFormatPrice:self.MA30 basePrice:self.high];
}
- (NSString *)MA60_format{
    return [NSString km7_market_getFormatPrice:self.MA60 basePrice:self.high];
}

-(NSString *)Volume_MA5_format{
    return [NSString km7_market_getFormatVolume:self.Volume_MA5];
}

- (NSString *)Volume_MA10_format{
    return [NSString km7_market_getFormatVolume:self.Volume_MA10];
}

- (NSString *)Volume_MA30_format{
    return [NSString km7_market_getFormatVolume:self.Volume_MA30];
}



-(NSString *)calOpenMPercent:(NSString *)mtype{
    CGFloat mn = [[self valueForKey:mtype] floatValue];
    return [NSString stringWithFormat:@"%.2f%%",(self.open - mn)/mn*100];
}
@end
