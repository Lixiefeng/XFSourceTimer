//
//  XFSourceTimer.m
//  XFSourceTimer
//
//  Created by Aron.li on 2020/11/9.
//

#import "XFSourceTimer.h"

@interface XFSourceTimer ()

@property (nonatomic, strong) dispatch_source_t sourceTimer;
@property (nonatomic, assign) BOOL repeats;
@property (nonatomic, copy) dispatch_block_t block;

@property (nonatomic, assign) BOOL isRunning;

@end


@implementation XFSourceTimer

+ (XFSourceTimer *)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(dispatch_block_t)block {
    XFSourceTimer *timer = [[XFSourceTimer alloc] initWithFireDate:[NSDate date] interval:interval repeats:repeats block:block];
    return timer;
}

+ (XFSourceTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(dispatch_block_t)block {
    XFSourceTimer *timer = [[XFSourceTimer alloc] initWithFireDate:[NSDate date] interval:interval repeats:repeats block:block];
    [timer resumeTimer];
    return timer;
}

- (instancetype)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(dispatch_block_t)block {
    if (self = [super init]) {
        self.repeats = repeats;
        self.block = [block copy];
        self.sourceTimer = [self createTimerWithFireDate:date interval:interval];
    }
    return self;
}

- (void)resumeTimer {
    if (self.isRunning) {
        return;
    }
    if (self.sourceTimer) {
        dispatch_resume(self.sourceTimer);
        self.isRunning = YES;
    }
}

- (void)suspendTimer {
    if (!self.isRunning) {
        return;
    }
    if (self.sourceTimer) {
        dispatch_suspend(self.sourceTimer);
        self.isRunning = NO;
    }
}

- (void)stopTimer {
    if (self.sourceTimer) {
        dispatch_source_cancel(self.sourceTimer);
        self.sourceTimer = nil;
        self.block = nil;
    }
}

#pragma mark - private method

- (dispatch_source_t)createTimerWithFireDate:(NSDate *)date interval:(NSTimeInterval)interval {
    NSTimeInterval time;
    NSDate *nowDate = [NSDate date];
    if ([nowDate isEqualToDate:date]) {
        time = 0;
    } else if ([date earlierDate:nowDate]) {
        time = 0;
    } else {
        time = date.timeIntervalSince1970 - nowDate.timeIntervalSince1970;
    }
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    uint64_t uInterval = (uint64_t)(interval * NSEC_PER_SEC);
    dispatch_time_t startDate = dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC);
    dispatch_source_set_timer(timer, startDate, uInterval, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (self.block) {
            self.block();
        }
        if (!self.repeats) {
            [self stopTimer];
        }
    });
    return timer;
}

@end
