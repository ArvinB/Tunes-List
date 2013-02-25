//
// << Add Legal Copyright Here >>
//

#import "MasterTunes.h"
#import "MasterControllers.h"

@implementation TunesParser

#pragma mark - Helper Methods:

- (void) _setStatusString:(NSString *)message {
	
	[self runBlockOnMainQueue:^{
		
		MasterObjectControls *controls = ((AppDelegate *)[NSApp delegate]).masterWindowController.masterViewController.controls;
		controls.statusMessage = message;
		
	}];
}

- (NSDictionary *) _getiTunesDict {
	
	NSURL *iTunesXMLURL = [MasterPath iTunesURL];
	if ( !iTunesXMLURL ) return nil;
	
	NSError *error = nil;
	NSData *iTunesData = [NSData dataWithContentsOfURL:iTunesXMLURL
											   options:NSDataReadingUncached
												 error:&error];
    if ( error ) {
        [((AppDelegate *)[NSApp delegate]) presentModalError:error];
        return nil;
    }
	
	return [NSPropertyListSerialization propertyListWithData:iTunesData
															   options:NSPropertyListImmutable
																format:nil
																 error:&error];
}

- (NSManagedObjectContext *) _getNewContext {
	
	AppDelegate *delegate = [NSApp delegate];
	NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
	[ctx setParentContext:delegate.masterData.managedObjectContext];
	return ctx;
}

#pragma mark - Initialization:

- (void) main {
	
	[self _setStatusString:TunesLocalizedString(@"TunesStart")];
	
	NSDictionary *iTunesDict = nil;
	if ( !(iTunesDict = [self _getiTunesDict]) ) return;
	
	TunesObjects *objects = [[TunesObjects alloc] initWithTunesDict:iTunesDict forContext:[self _getNewContext]];
	
	[self _setStatusString:TunesLocalizedString(@"TunesRead")];
	[TunesTracks tunesTracksForObjects:objects];
}

@end
