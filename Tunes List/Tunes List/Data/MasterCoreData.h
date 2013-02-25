//
// << Add Legal Copyright Here >>
//


static NSString* const kRelDBToTracks			= @"relToTracks";
static NSString* const kRelTracksToDB			= @"relToDB";

static NSString* const kEntityTunesDB			= @"TunesDB";
static NSString* const kTunesDBID				= @"id";
static NSString* const kTunesDBVersion			= @"version";
static NSString* const kTunesDBDate				= @"date";

static NSString* const kEntityTunesTracks		= @"TunesTracks";
static NSString* const kTunesTracksID			= @"id";
static NSString* const kTunesTracksTrackID		= @"trackID";
static NSString* const kTunesTracksName			= @"name";
static NSString* const kTunesTracksLocation		= @"location";
static NSString* const kTunesTracksHasVideo		= @"hasVideo";

@interface MasterCoreData : NSObject

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void) resetStore;

@end
