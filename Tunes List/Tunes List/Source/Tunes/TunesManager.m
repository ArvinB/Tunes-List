//
// << Add Legal Copyright Here >>
//

#import "MasterTunes.h"

@interface TunesManager ()
@property (readwrite, nonatomic, strong) CommReceptionist *tunesSource;
@property (readwrite, strong, nonatomic) NSOperationQueue *queue;
@end

@implementation TunesManager

@synthesize tunesSource;
@synthesize manageTunes, completionBlock, queue;

#pragma mark - Private Methods:

- (void) _handleTunesNote:(NSNotification *)note {
	
	if ( !self.isTunesManaged ) return;
	
	[CommTimer scheduleTimerWithInterval:kTunesDelay block:^{
		
		if ( [self.queue operationCount] < 2 )
			[self parseTunes];
	}];
}

#pragma mark - Public Methods:

- (CommReceptionist *) observeQueueCountForBlock:(CommReceptionistTaskBlock)block {
	
	CommReceptionist *observer =
	[CommReceptionist receptionistForKeyPath:@"operationCount"
									  object:self.queue
									   queue:[NSOperationQueue currentQueue]
										task:block];
	return observer;
}

- (void) parseTunes {
	
	TunesParser *parser = [[TunesParser alloc] init];

	if ( self.completionBlock )
		[parser setCompletionBlock:self.completionBlock];
	
	[self.queue addOperation:parser];
}

- (void) clearTunes {
	
	[((AppDelegate *)[NSApp delegate]).masterData resetStore];
}

#pragma mark - Initialization:

- (void) setupTunesNote {
	
	NSOperationQueue *noteQueue = [[NSOperationQueue alloc] init];
	NSDistributedNotificationCenter *center = [NSDistributedNotificationCenter defaultCenter];
    self.tunesSource = [CommReceptionist receptionistForName:kTunesNoteNameSourceSaved object:center queue:noteQueue sender:nil task:^(NSNotification *note) {
        
		SEL selector = @selector(_handleTunesNote:);
		NSMethodSignature   *signature  = [self methodSignatureForSelector:selector];
		NSInvocation        *invocation = [NSInvocation invocationWithMethodSignature:signature];
		[invocation setTarget:self];
		[invocation setSelector:selector];
		[invocation setArgument:&note atIndex:2];
        [invocation invoke];
		
    }];
}

- (id) init {
	
	if ( (self = [super init]) ) {
		
		NSString *queuLabel = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
		queuLabel = [queuLabel stringByAppendingPathExtension:NSStringFromClass([self class])];
		
		self.queue = [[NSOperationQueue alloc] init];
		[self.queue setMaxConcurrentOperationCount:1];

		self.completionBlock = nil;
		
		[self setupTunesNote];
		
	} return self;
}

SINGLETON_GCD( TunesManager )

@end
