//
// << Add Legal Copyright Here >>
//

#import "MasterControllers.h"

@interface MasterObjectControls ()
@property (readwrite, nonatomic, getter=isStatusOnDelay) BOOL statusDelay;
@end

static NSTimeInterval const kStatusDelay = 3.0;

@implementation MasterObjectControls

@synthesize statusDelay, lockControls, statusMessage = _statusMessage;
@synthesize masterProgress, masterStatus, masterSwitch, masterSwitchState;

- (id) initWithCoder:(NSCoder *)aDecoder {

	if ( (self = [super initWithCoder:aDecoder]) ) {
		
		self.masterSwitchState = SwitchOffState;
		
	} return self;
}

- (void) setStatusMessage:(NSString *)message {
	
	if ( self.isStatusOnDelay ) return;
	
	[self willChangeValueForKey:@"statusMessage"];
	_statusMessage = message;
	[self didChangeValueForKey:@"statusMessage"];
}

- (void) setTempStatusMessage:(NSString *)strStatus {
	
	if ( self.isStatusOnDelay ) return;
	
	self.statusMessage = strStatus;
	self.statusDelay = YES;
	
	__block MasterObjectControls *this = self;
	[CommTimer scheduleTimerWithInterval:kStatusDelay block:^{
		
		this.statusDelay = NO;
		this.statusMessage = nil;
		
	}];
}

@end
