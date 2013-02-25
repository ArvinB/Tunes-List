//
// << Add Legal Copyright Here >>
//

#import "MasterControllers.h"

static NSString* const kMasterWindowXIB = @"MasterWindow";

@implementation MasterWindowController

@synthesize masterWindowTitle, masterViewController;

#pragma mark - Initialization:

- (void) setupMasterView {
	
	self.masterViewController = [[MasterViewController alloc] init];
	self.masterViewController.representedObject = self;
	
	NSView *masterView = self.masterViewController.view;
	
	[self setNextResponder:self.masterViewController];
	[self.window.contentView addSubview:masterView];

	
	NSDictionary *views = NSDictionaryOfVariableBindings( masterView );
	[self.window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[masterView]|" options:0 metrics:nil views:views]];
	[self.window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[masterView]|" options:0 metrics:nil views:views]];
	[self.window.contentView layoutSubtreeIfNeeded];
}

- (id) init {
	
	if ( (self = [super initWithWindowNibName:kMasterWindowXIB]) ) {
		
		[self.window makeKeyAndOrderFront:self];
		[NSApp activateIgnoringOtherApps:YES];
		
		self.masterWindowTitle = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
		
	} return self;
}

- (void) awakeFromNib {
	
	[super awakeFromNib];
	[self setupMasterView];
}

@end
