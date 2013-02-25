//
// << Add Legal Copyright Here >>
//


#import "MasterData.h"

static NSString* const kMasterDataModel = @"TunesList";

@implementation MasterCoreData

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (NSManagedObjectModel *) managedObjectModel {

    if (_managedObjectModel)
        return _managedObjectModel;
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kMasterDataModel withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
	
    if (_persistentStoreCoordinator)
        return _persistentStoreCoordinator;
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    NSError *error = nil;
    
    NSPersistentStoreCoordinator *coord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
	if ( ![coord addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error] ) {
		
        [((AppDelegate *)[NSApp delegate]) presentModalError:error];
        return nil;
    }
	
    _persistentStoreCoordinator = coord;
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *) managedObjectContext {

    if (_managedObjectContext)
        return _managedObjectContext;
    
	NSPersistentStoreCoordinator *coord = [self persistentStoreCoordinator];
    
	if ( !coord ) return nil;
	
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coord];
	
    return _managedObjectContext;
}

- (void) resetStore {
	
	if (!_persistentStoreCoordinator)
		return;
	
	NSPersistentStoreCoordinator *coord = [self persistentStoreCoordinator];
	NSArray *stores = [coord persistentStores];
	
	for ( NSPersistentStore *store in stores )
		[coord removePersistentStore:store error:nil];
	
	_persistentStoreCoordinator = nil;
	_managedObjectContext = nil;
	
	[self managedObjectContext];
}

- (id) init {
	
	if ( (self = [super init]) ) {
		
		[self managedObjectContext];
		
	} return self;
}

@end
