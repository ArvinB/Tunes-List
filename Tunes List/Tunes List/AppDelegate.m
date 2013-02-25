//
// << Add Legal Copyright Here >>
//

#import "AppDelegate.h"
#import "MasterControllers.h"
#import <objc/runtime.h>

@implementation AppDelegate

@synthesize masterWindowController, masterData;

#pragma mark - Public Methods:

- (void) presentModalError:(NSError *)error {
	
	[self runBlockOnMainQueue:^{
		[NSApp presentError:error
			 modalForWindow:[NSApp mainWindow]
				   delegate:nil
		 didPresentSelector:nil
				contextInfo:nil];
	}];
}

#pragma mark - Delegate Methods:

- (void) applicationDidFinishLaunching:(NSNotification *)aNotification {
	
	self.masterData = [[MasterCoreData alloc] init];
	self.masterWindowController = [[MasterWindowController alloc] init];
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender { return YES; }


@end

#pragma mark - NSObject Category:
#pragma mark -

@implementation NSObject (CategoryAppDelegate)

- (void) associateValue:(id)value withKey:(NSString *)aKey {
    
	objc_setAssociatedObject( self, (__bridge void *)aKey, value, OBJC_ASSOCIATION_RETAIN );
}

- (void) removeAssociatedValueForKey:(NSString *)aKey {
	
	id object = [self associatedValueForKey:aKey];
	if ( object ) objc_removeAssociatedObjects( object );
}

- (id) associatedValueForKey:(NSString *)aKey {
    
	return objc_getAssociatedObject( self, (__bridge void *)aKey );
}

- (void) runBlockOnMainQueue:(void (^)(void))block {
	
	if ( [NSThread isMainThread] ) block();
    
    else
		dispatch_sync( dispatch_get_main_queue(), block );
}

- (NSString *) uniqueIdentifier {
	
	CFUUIDRef uniqueID = CFUUIDCreate( kCFAllocatorDefault );
    NSString *strUUID = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, uniqueID);
    CFRelease( uniqueID );
	
	return strUUID;
}

@end