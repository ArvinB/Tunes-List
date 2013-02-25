//
// << Add Legal Copyright Here >>
//

@interface CommTimer : NSObject

+ (CommTimer *) repeatingTimerWithInterval:(NSTimeInterval)interval block:(dispatch_block_t)block;
+ (void) scheduleTimerWithInterval:(NSTimeInterval)interval block:(dispatch_block_t)block;

- (void) fire;
- (void) invalidate;

@end
