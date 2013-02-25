//
// << Add Legal Copyright Here >>
//

#import "MasterTunes.h"

@interface TunesObjects ()
@property (readwrite, strong, nonatomic) NSDictionary *tunesDict;
@property (readwrite, strong, nonatomic) NSManagedObjectContext	*context;
@end

@implementation TunesObjects
@synthesize tunesDict, context;

#pragma mark - Helper Methods:

- (void) _updateMainContext {
	
	NSManagedObjectContext *mainMOC = ((AppDelegate*)[NSApp delegate]).masterData.managedObjectContext;
	
	[mainMOC performBlock:^{
		
		NSError *error = nil; [mainMOC save:&error];
		if ( error ) [((AppDelegate *)[NSApp delegate]) presentModalError:error];
	}];
}

#pragma mark - Public Methods:

- (NSSet *) tunesTracksForDB:(NSManagedObject *)dbObject {
	
	if ( !dbObject ) return nil;
	return [dbObject valueForKey:kRelDBToTracks];
}

- (void) removeObjectsForSetIDs:(NSSet *)setIDs {
	
	if ( 0 == [setIDs count] ) return;
	NSError *error = nil;
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id IN %@", setIDs];
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kEntityTunesTracks];
	[request setPredicate:predicate];
	
	NSArray *trackObjects = [self.context executeFetchRequest:request error:&error];
	if ( error ) { [((AppDelegate *)[NSApp delegate]) presentModalError:error]; return; }
	
	for ( NSManagedObject *trackObject in trackObjects )
		[self.context deleteObject:trackObject];
	
	[self.context save:&error];
	if ( error ) [((AppDelegate *)[NSApp delegate]) presentModalError:error];
	else [self _updateMainContext];
}

- (void) updateObjectsForTracks:(NSSet *)tracks {
		
	if ( 0 == [tracks count] ) return;
	NSError *error = nil;
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id IN %@", [tracks valueForKey:@"uniqueID"]];
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kEntityTunesTracks];
	[request setPredicate:predicate];
	
	NSArray *trackObjects = [self.context executeFetchRequest:request error:&error];
	if ( error ) { [((AppDelegate *)[NSApp delegate]) presentModalError:error]; return; }
	
	for ( NSManagedObject *trackObject in trackObjects ) {
		
		NSPredicate *trackPred = [NSPredicate predicateWithFormat:@"uniqueID LIKE[cd] %@", [trackObject valueForKey:kTunesTracksID]];
		TunesTrack *track = [[tracks filteredSetUsingPredicate:trackPred] anyObject];
		
		[trackObject setValue:track.trackID forKey:kTunesTracksTrackID];
		[trackObject setValue:track.name forKey:kTunesTracksName];
		[trackObject setValue:track.location forKey:kTunesTracksLocation];
		[trackObject setValue:[NSNumber numberWithBool:track.hasVideo] forKey:kTunesTracksHasVideo];
	}
	
	[self.context save:&error];
	if ( error ) [((AppDelegate *)[NSApp delegate]) presentModalError:error];
	else [self _updateMainContext];
}

- (void) addObjectsForTracks:(NSSet *)tracks withDB:(NSManagedObject *)dbObject {
		
	if ( 0 == [tracks count] ) return;
	NSError *error = nil;
	
	for ( TunesTrack *track in tracks ) {
		
		NSManagedObject *trackObject = [NSEntityDescription insertNewObjectForEntityForName:kEntityTunesTracks
																	 inManagedObjectContext:self.context];
		
		[trackObject setValue:track.uniqueID forKey:kTunesTracksID];
		[trackObject setValue:track.trackID forKey:kTunesTracksTrackID];
		[trackObject setValue:track.name forKey:kTunesTracksName];
		[trackObject setValue:track.location forKey:kTunesTracksLocation];
		[trackObject setValue:[NSNumber numberWithBool:track.hasVideo] forKey:kTunesTracksHasVideo];
		[trackObject setValue:dbObject forKey:kRelTracksToDB];
	}
	
	[self.context save:&error];
	if ( error ) [((AppDelegate *)[NSApp delegate]) presentModalError:error];
	else [self _updateMainContext];
}

#pragma mark - Getter Methods:

- (NSString *) tunesID		{ return [tunesDict objectForKey:@"Library Persistent ID"]; }
- (NSString *) tunesVer		{ return [tunesDict objectForKey:@"Application Version"];	}
- (NSDate   *) tunesDate	{ return [tunesDict objectForKey:@"Date"];					}

- (NSManagedObject *) tunesDB {
	
	NSManagedObject *tunesDBObject = nil;
	
	NSError *error = nil;
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kEntityTunesDB];
	NSArray *tunesDBs = [self.context executeFetchRequest:request error:&error];
	
	if ( error ) {
		[((AppDelegate *)[NSApp delegate]) presentModalError:error];
		return nil;
	}

	if ( [tunesDBs count] > 0 )
		tunesDBObject = [tunesDBs objectAtIndex:0];
	
	else
		tunesDBObject = [NSEntityDescription insertNewObjectForEntityForName:kEntityTunesDB inManagedObjectContext:self.context];
	
	[tunesDBObject setValue:self.tunesID	forKey:kTunesDBID];
	[tunesDBObject setValue:self.tunesVer	forKey:kTunesDBVersion];
	[tunesDBObject setValue:self.tunesDate	forKey:kTunesDBDate];
	
	[self.context save:&error];
	
	if ( error ) {
		
		[((AppDelegate *)[NSApp delegate]) presentModalError:error];
		return nil;
		
	}
	
	[self _updateMainContext];
	return tunesDBObject;
}

#pragma mark - Initialization:

- (id) initWithTunesDict:(NSDictionary *)dict
			  forContext:(NSManagedObjectContext *)ctx {
	
	if ( (self = [super init]) ) {
		
		self.tunesDict = dict;
		self.context = ctx;
		
	} return self;
}

@end
