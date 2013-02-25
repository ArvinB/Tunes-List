//
// << Add Legal Copyright Here >>
//

@class MasterWindowController, MasterCoreData;

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (readwrite, strong, nonatomic) MasterWindowController *masterWindowController;
@property (readwrite, strong, nonatomic) MasterCoreData *masterData;
- (void) presentModalError:(NSError *)error;
@end

@interface NSObject (CategoryAppDelegate)
- (void) associateValue:(id)value withKey:(NSString *)aKey;
- (void) removeAssociatedValueForKey:(NSString *)aKey;
- (id) associatedValueForKey:(NSString *)aKey;
- (void) runBlockOnMainQueue:(void (^)(void))block;
@property (readonly, strong, nonatomic) NSString *uniqueIdentifier;
@end