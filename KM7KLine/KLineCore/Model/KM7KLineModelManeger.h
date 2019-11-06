//
//  KM7KLineModelManeger.h
//  Stark
//
//  Created by tangl on 2019/8/9.
//  Copyright © 2019 km7. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KM7StockGlobalVariable.h"

NS_ASSUME_NONNULL_BEGIN

@class KM7KLineModel;
@interface KM7KLineModelManeger : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<KM7KLineModel *> *modelsArr;
@property (nonatomic, assign) KM7KlineDateType dateType;


- (void)prependModelsArr:(NSArray<NSDictionary *> *)arr;

- (BOOL)appendModelsArr:(NSArray<NSDictionary *> *)arr;

- (void)refreshModelsArr:(NSArray<NSDictionary *> *)arr;

@end

NS_ASSUME_NONNULL_END
