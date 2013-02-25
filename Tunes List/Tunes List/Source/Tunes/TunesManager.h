//
// << Add Legal Copyright Here >>
//

typedef void (^TunesCompletionHandler)(void);

@interface TunesManager : NSObject

@property (readwrite, nonatomic, getter=isTunesManaged) BOOL manageTunes;
@property (readonly, strong, nonatomic) NSOperationQueue *queue;
@property (readwrite, strong, nonatomic) TunesCompletionHandler completionBlock;

- (CommReceptionist *) observeQueueCountForBlock:(CommReceptionistTaskBlock)block;
- (void) parseTunes;
- (void) clearTunes;

+ (TunesManager *) sharedTunesManager;

@end
