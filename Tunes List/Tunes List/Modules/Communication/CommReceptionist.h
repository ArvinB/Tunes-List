//
// << Add Legal Copyright Here >>
//

typedef void (^CommReceptionistNoteBlock)(NSNotification *note);
typedef void (^CommReceptionistTaskBlock)(NSString *keyPath, id object, NSDictionary *change);

@interface CommReceptionist : NSObject

/*!
 * @discussion Use this class for observing values that change
 * on a secondary thread and then trigger the event to be 
 * handled in another execution context. Simply call
 * the convenience method to redirect the notification from 
 * the secondary thread to another execution context.
 * 
 * Note: Use [NSOperationQueue mainQueue] for operations on the main thread
 *
 * @example 	CommReceptionist * receptionist;
 *				receptionist = [CommReceptionist receptionistForKeyPath:@"value" 
 *																object:objOnThread 
 *																 queue:mainQueue 
 *						task:^(CommReceptionistTaskBlock) {
 *
 *						MyClass * classObj	= object;
 *					 SomeObject * newObjValue = [change objectForKey:NSKeyValueChangeNewKey];
 *
 *					<< Do stuff here >>
 *				}];
 */

#pragma mark -

+ (id) receptionistForKeyPath:(NSString *)path
					   object:(id)obj
						queue:(NSOperationQueue *)queue
						 task:(CommReceptionistTaskBlock)block;

- (void) removeReceptionistForKeyPath;

+ (id) receptionistForName:(NSString *)name
                    object:(id)noteObj
                     queue:(NSOperationQueue *)queue
                    sender:(id)senderObj
                      task:(CommReceptionistNoteBlock)block;

- (void) removeReceptionistForName;

+ (void) postLocalNote:(NSString *)name sender:(id)object info:(NSDictionary *)dict;
+ (void) postGlobalNote:(NSString *)name;

+ (id) observeLocal:(NSString *)name note:(CommReceptionistNoteBlock)block;
+ (id) observeGlobal:(NSString *)name note:(CommReceptionistNoteBlock)block;

@end
