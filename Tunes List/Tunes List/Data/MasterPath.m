//
// << Add Legal Copyright Here >>
//


#import "MasterData.h"
#import <pwd.h>

@implementation MasterPath

static NSString* const kPathiApps		= @"com.apple.iApps.plist";
static NSString* const kPathiTunesDB	= @"iTunesRecentDatabases";
static NSString* const kPathiPhotoDB	= @"iPhotoRecentDatabases";

#pragma mark - Helper Methods:

+ (NSURL *) _iAppsPlist {
	
	NSURL *prefs = nil;
	if ( !(prefs = [NSURL preferencesPOSIXURL]) ) return nil;
	return [prefs URLByAppendingPathComponent:kPathiApps isDirectory:NO];
}

+ (NSURL *) _iAppsURLForKey:(NSString *)key {
	
	NSURL *iApps = [MasterPath _iAppsPlist];
	if ( !iApps ) return nil;
	
	NSDictionary *iAppsDict = iApps.pListDict;
	if ( !iAppsDict ) return nil;
	
	NSArray *databases = [iAppsDict objectForKey:key];
	if ( [databases count] > 0 ) return [NSURL URLWithString:[databases objectAtIndex:0]];
	
	return nil;
}

#pragma mark - Class Methods:

+ (NSURL *) iTunesURL { return [MasterPath _iAppsURLForKey:kPathiTunesDB]; }
+ (NSURL *) iPhotoURL { return [MasterPath _iAppsURLForKey:kPathiPhotoDB]; }

@end

#pragma mark - NSURL Category:

@implementation NSURL (CategoryMasterPath)

static NSString* const kLocalPathPreferences = @"Preferences";

#pragma mark - Helper Methods:

+ (NSURL *) _libraryPOSIXURL {
	
	struct passwd *pwUser  = getpwuid(getuid());
    const char    *homeDir = pwUser->pw_dir;
    NSURL *homeURL = [NSURL fileURLWithPath:@(homeDir) isDirectory:YES];
	
	NSArray *libURLs = [[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask];
	
	if ( [libURLs count] > 0 ) {
		
		NSURL *libURL = [libURLs objectAtIndex:0];
		NSString *libComponent = [libURL lastPathComponent];
		return [homeURL URLByAppendingPathComponent:libComponent];
		
	} return nil;
}

#pragma mark -

- (NSDictionary *) pListDict {
	
	NSData *plistData = [NSData dataWithContentsOfURL:self];
	
	if ( [plistData length] > 0 ) {
		
		return (NSDictionary *)[NSPropertyListSerialization propertyListWithData:plistData
																		 options:NSPropertyListImmutable
																		  format:nil error:nil];
	} return nil;
}

+ (NSURL *) preferencesPOSIXURL {
	
	NSURL *libPOSIX = [NSURL _libraryPOSIXURL];
	if ( !libPOSIX ) return nil;
	return [libPOSIX URLByAppendingPathComponent:kLocalPathPreferences];
}

@end
