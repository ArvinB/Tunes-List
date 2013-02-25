//
// << Add Legal Copyright Here >>
//

#import "MasterTunes.h"

typedef NS_ENUM(NSUInteger, CompareType) {
	
	AddSetType		= 0,
	RemoveSetType	= 1,
	UpdateSetType	= 2
};

typedef NSSet* (^CompareSets)(NSSet*, NSSet*, CompareType);

@interface TunesTrack ()
@property (readwrite, strong, nonatomic) NSString *uniqueID;
@property (readwrite, strong, nonatomic) NSString *name;
@property (readwrite, strong, nonatomic) NSString *location;
@property (readwrite, strong, nonatomic) NSNumber *trackID;
@property (readwrite, nonatomic, getter=hasVideo) BOOL video;
@end

@implementation TunesTrack
@synthesize uniqueID, name, location, trackID, video;
@end

@interface TunesTracks ()
@property (readwrite, strong, nonatomic) NSSet *allTracks;
@property (readwrite, strong, nonatomic) NSSet *allTrackObjects;
@end

@implementation TunesTracks

@synthesize allTracks, allTrackObjects;

#pragma mark - Helper Methods:

- (CompareSets) _compareSetsBlock {
	
	return ^(NSSet *set1, NSSet *set2, CompareType type) {
		
		switch (type) {
				
			case AddSetType: {
				NSMutableSet *mSet1 = [NSMutableSet setWithSet:set1];
				[mSet1 minusSet:set2];
				return [NSSet setWithSet:mSet1];
			}
				
			case RemoveSetType: {
				NSMutableSet *mSet2 = [NSMutableSet setWithSet:set2];
				[mSet2 minusSet:set1];
				return [NSSet setWithSet:mSet2];
			}
				
			case UpdateSetType: {
				NSMutableSet *mSet2 = [NSMutableSet setWithSet:set2];
				[mSet2 intersectSet:set1];
				return [NSSet setWithSet:mSet2];
			}
				
		} return [NSSet set];
	};
}

- (NSSet *) _allTracksInSet:(NSSet *)aSet {
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uniqueID IN %@", aSet];
	return [self.allTracks filteredSetUsingPredicate:predicate];
}

#pragma mark - Getters:

- (NSSet *) audioTracks {
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"video == 0"];
	return [self.allTracks filteredSetUsingPredicate:predicate];
}

- (NSSet *) videoTracks {
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"video == 1"];
	return [self.allTracks filteredSetUsingPredicate:predicate];
}

#pragma mark - Initialization:

- (void) setupTrackObjectsForObjects:(TunesObjects *)objects {
	
	[objects.context performBlockAndWait:^{
		
		NSManagedObject *library = objects.tunesDB;
		NSSet *trackObjs = [objects tunesTracksForDB:library];
		if ( !trackObjs ) return;
		
		NSSet *masterIDs  = [self.allTracks valueForKey:@"uniqueID"];
		NSSet *currentIDs = [trackObjs valueForKey:kTunesTracksID];
		
		NSSet *removeSet = [self _compareSetsBlock]( masterIDs, currentIDs, RemoveSetType );
		NSSet *updateSet = [self _compareSetsBlock]( masterIDs, currentIDs, UpdateSetType );
		NSSet *addSet	 = [self _compareSetsBlock]( masterIDs, currentIDs, AddSetType );
		
		[objects removeObjectsForSetIDs:removeSet];
		[objects updateObjectsForTracks:[self _allTracksInSet:updateSet]];
		[objects addObjectsForTracks:[self _allTracksInSet:addSet] withDB:library];
		
		self.allTrackObjects = [objects tunesTracksForDB:library];
	}];
}

- (void) setupTracksForObjects:(TunesObjects *)objects {
	
	NSDictionary *tracksDict = [objects.tunesDict objectForKey:@"Tracks"];
	if ( !tracksDict ) tracksDict = @{ };
	
	NSMutableArray *tracks = [NSMutableArray array];
	
	[tracksDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		
		NSDictionary *trackDict = (NSDictionary *)obj;
		
		id bDisabled = [trackDict objectForKey:@"Disabled"];
		id bVideo = [trackDict objectForKey:@"Has Video"];
		
		if ( (!bDisabled) || (![bDisabled boolValue]) ) {
		
		TunesTrack *track = [[TunesTrack alloc] init];
		track.uniqueID = [trackDict objectForKey:@"Persistent ID"];
		track.name = [trackDict objectForKey:@"Name"];
		track.location = [trackDict objectForKey:@"Location"];
		track.trackID = [trackDict objectForKey:@"Track ID"];
		track.video = bVideo ? [bVideo boolValue] : NO;
		
			if ( (track.uniqueID) && (track.name) && (track.location) && (track.trackID) )
				[tracks addObject:track];
		}
		
	}]; self.allTracks = [NSSet setWithArray:tracks];
}

+ (id) tunesTracksForObjects:(TunesObjects *)objects {
	
	TunesTracks *tracks = [[self alloc] init];
	
	[tracks setupTracksForObjects:objects];
	[tracks setupTrackObjectsForObjects:objects];
	
	return tracks;
}

@end