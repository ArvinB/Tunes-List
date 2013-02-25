//
// << Add Legal Copyright Here >>
//

@interface TunesObjects : NSObject

@property (readonly, strong, nonatomic) NSDictionary *tunesDict;
@property (readonly, strong, nonatomic) NSManagedObjectContext *context;

@property (readonly, strong, nonatomic) NSString *tunesID;
@property (readonly, strong, nonatomic) NSString *tunesVer;
@property (readonly, strong, nonatomic) NSDate *tunesDate;
@property (readonly, strong, nonatomic) NSManagedObject *tunesDB;

- (NSSet *) tunesTracksForDB:(NSManagedObject *)dbObject;
- (void) removeObjectsForSetIDs:(NSSet *)setIDs;
- (void) updateObjectsForTracks:(NSSet *)tracks;
- (void) addObjectsForTracks:(NSSet *)tracks withDB:(NSManagedObject *)dbObject;

- (id) initWithTunesDict:(NSDictionary *)dict forContext:(NSManagedObjectContext *)ctx;

@end
