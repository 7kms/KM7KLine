//
//  NSTimer+KM7Extention.h
//  Stark
//
//  Created by float.. on 2019/7/19.
//  Copyright © 2019 km7. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (KM7Extention)

+ (NSTimer *)km7_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)(void))block repeats:(BOOL)repeats;
@end

NS_ASSUME_NONNULL_END
