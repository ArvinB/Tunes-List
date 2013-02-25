//
// << Add Legal Copyright Here >>
//

#import "MasterControllers.h"

@interface MasterViewController ()
@property (readwrite, strong, nonatomic) CommReceptionist *observeParser;
@property (readwrite, strong, nonatomic) IBOutlet MasterObjectControls *controls;
@property (readonly, strong, nonatomic) IBOutlet NSArrayController *allTracks;
@property (readonly, strong, nonatomic) IBOutlet NSArrayController *audioTracks;
@property (readonly, strong, nonatomic) IBOutlet NSArrayController *videoTracks;
@end

static NSString* const kMasterViewXIB = @"MasterView";

@implementation MasterViewController

@synthesize observeParser, controls;
@synthesize allTracks, audioTracks, videoTracks;

- (IBAction) masterSwitchAction:(id)sender {
	
	SwitchState state = self.controls.masterSwitchState;
	
	switch ( state ) {
		case SwitchOnState: {
			
			TUNES.manageTunes = YES;
			[TUNES parseTunes];
			break;
		}
			
		case SwitchOffState: {
			
			TUNES.manageTunes = NO;
			
			[self.controls	  setManagedObjectContext:nil];
			[self.allTracks   setManagedObjectContext:nil];
			[self.audioTracks setManagedObjectContext:nil];
			[self.videoTracks setManagedObjectContext:nil];
			
			[TUNES clearTunes];
			
			NSManagedObjectContext *context = ((AppDelegate*)[NSApp delegate]).masterData.managedObjectContext;
			[self.controls	  setManagedObjectContext:context];
			[self.allTracks	  setManagedObjectContext:context];
			[self.audioTracks setManagedObjectContext:context];
			[self.videoTracks setManagedObjectContext:context];
			
			break;
		}
	}
}

#pragma mark - Initialization:

- (void) setupSortDescriptors {
	
	NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	[self.audioTracks setSortDescriptors:@[descriptor]];
	[self.videoTracks setSortDescriptors:@[descriptor]];
}

- (void) setupTunes {
	
	TUNES;
	
	self.observeParser = [TUNES observeQueueCountForBlock:^(NSString *keyPath, id object, NSDictionary *change) {
		
		NSUInteger count = [[change objectForKey:NSKeyValueChangeNewKey] unsignedIntegerValue];
		self.controls.lockControls = count;
	}];
	
	TUNES.completionBlock = ^() {
		
		[self.controls setTempStatusMessage:TunesLocalizedString(@"TunesEnd")];
		
	};
	
	self.controls.masterSwitchState = SwitchOnState;
	[self masterSwitchAction:self.controls.masterSwitch];
}

- (id) init {
	
	self = [super initWithNibName:kMasterViewXIB bundle:nil];
	return self;
}

- (void) loadView {
	
	[super loadView];
	[self setupSortDescriptors];
	[self setupTunes];
}

@end
