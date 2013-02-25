//
// << Add Legal Copyright Here >>
//

#import "Communication.h"

@interface CommTimer ()
@property (readwrite, strong, nonatomic) __attribute__((NSObject)) dispatch_source_t source;
@property (readwrite, copy, nonatomic) dispatch_block_t timerBlock;
@end

@implementation CommTimer

@synthesize source, timerBlock;

#pragma mark - Class Methods:

+ (CommTimer *) repeatingTimerWithInterval:(NSTimeInterval)interval block:(void (^)(void))block {
	
	CommTimer *timer = [[self alloc] init];
	timer.timerBlock = block;
	timer.source = dispatch_source_create( DISPATCH_SOURCE_TYPE_TIMER,
										   0, 0,
	 									   dispatch_get_main_queue() );
	
	uint64_t time = (uint64_t)(interval * NSEC_PER_SEC);
	dispatch_source_set_timer( timer.source,
							   dispatch_time(DISPATCH_TIME_NOW, time),
							   time, 0 );
	dispatch_source_set_event_handler( timer.source, block );
	dispatch_resume( timer.source );
	
	return timer;
}

+ (void) scheduleTimerWithInterval:(NSTimeInterval)interval block:(dispatch_block_t)block {
	
	dispatch_after( dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), dispatch_get_main_queue(), block );
}

#pragma mark - Repeating Timer Methods:

- (void) fire { self.timerBlock(); }

- (void) invalidate {
	
	if ( self.source ) {
		
		dispatch_source_cancel( self.source );
		dispatch_release( self.source );
		self.source = nil;
		
	} self.timerBlock = nil;
}

@end
