//
//  NSTimer+KM7Extention.m
//  Stark
//
//  Created by float.. on 2019/7/19.
//  Copyright © 2019 km7. All rights reserved.
//

#import "NSTimer+KM7Extention.h"

@implementation NSTimer (KM7Extention)


+ (NSTimer *)km7_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)(void))block repeats:(BOOL)repeats {
  
  return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(km7_blockSelector:) userInfo:[block copy] repeats:repeats];
}

+ (void)km7_blockSelector:(NSTimer *)timer {
  
  void(^block)(void) = timer.userInfo;
  if (block) {
    block();
  }
}

@end
