//
//  XFSourceTimer.h
//  XFSourceTimer
//
//  Created by Aron.li on 2020/11/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XFSourceTimer : NSObject

+ (XFSourceTimer *)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(dispatch_block_t)block;

+ (XFSourceTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(dispatch_block_t)block;

- (instancetype)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(dispatch_block_t)block;

/// 开启定时器
- (void)resumeTimer;

/// 暂停定时器
- (void)suspendTimer;

/// 停止定时器
- (void)stopTimer;

@end

NS_ASSUME_NONNULL_END
