//
// << Add Legal Copyright Here >>
//

#import "Communication.h"

#pragma mark - Private Interface:

@interface CommReceptionist ()
@property (readwrite, nonatomic, strong) id observedName;
@property (readwrite, nonatomic, strong) id observedObject;
@property (readwrite, nonatomic, strong) NSString *observedKeyPath;
@property (readwrite, nonatomic, strong) NSOperationQueue *observedQueue;
@property (readwrite, nonatomic, copy  ) CommReceptionistTaskBlock taskBlock;
@end

#pragma mark - Implementation:

@implementation CommReceptionist

@synthesize observedName;
@synthesize observedObject;
@synthesize observedKeyPath;
@synthesize observedQueue;
@synthesize taskBlock;

#pragma mark - KVO Receptionist:

+ (id) receptionistForKeyPath:(NSString *)path
					   object:(id)obj
						queue:(NSOperationQueue *)queue
						 task:(CommReceptionistTaskBlock)block {
	
    CommReceptionist *receptionist = [[self alloc] init];
	
    receptionist.observedKeyPath = path;
    receptionist.observedQueue   = queue;
    receptionist.taskBlock       = block;
    receptionist.observedObject	 = obj;
	
    [obj addObserver:receptionist 
		  forKeyPath:path
             options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
			 context:0];
	
    return receptionist;
}

- (void) observeValueForKeyPath:(NSString *)keyPath 
                       ofObject:(id)object 
                         change:(NSDictionary *)change 
                        context:(void *)context {
    
    CommReceptionistTaskBlock block = self.taskBlock;
    
    [self.observedQueue addOperationWithBlock:^{ 
        
        block( keyPath, object, change ); 
    
    }];
}

- (void) removeReceptionistForKeyPath { [self.observedObject removeObserver:self forKeyPath:self.observedKeyPath]; }

#pragma mark - NSNotification Receptionist:

+ (id) receptionistForName:(NSString *)name
                    object:(id)noteObj
                     queue:(NSOperationQueue *)queue
                    sender:(id)senderObj
                      task:(CommReceptionistNoteBlock)block {
	
    CommReceptionist *receptionist = [[self alloc] init];
	
    receptionist.observedKeyPath = name;
    receptionist.observedQueue   = queue;
    receptionist.observedObject	 = noteObj;
    
	
    receptionist.observedName = [noteObj addObserverForName:name 
                                                     object:senderObj 
                                                      queue:queue 
                                                 usingBlock:block];
    return receptionist;
}

- (void) removeReceptionistForName { [self.observedObject removeObserver:self.observedName name:self.observedKeyPath object:nil]; }

#pragma mark - Sending Notification:

+ (void) postLocalNote:(NSString *)name sender:(id)obj info:(NSDictionary *)dict {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:name object:obj userInfo:dict];
}

+ (void) postGlobalNote:(NSString *)name {
    
    NSDistributedNotificationCenter *center = [NSDistributedNotificationCenter defaultCenter];
    [center postNotificationName:name
						  object:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
						userInfo:nil
			  deliverImmediately:YES];
}

#pragma mark - Observing Notification:

+ (id) observeLocal:(NSString *)name note:(CommReceptionistNoteBlock)block {
    
    return [CommReceptionist receptionistForName:name
                                          object:[NSNotificationCenter defaultCenter]
                                           queue:[NSOperationQueue currentQueue]
                                          sender:nil
                                            task:block];
}

+ (id) observeGlobal:(NSString *)name note:(CommReceptionistNoteBlock)block {
	
    return [CommReceptionist receptionistForName:name
                                          object:[NSDistributedNotificationCenter defaultCenter]
                                           queue:[NSOperationQueue mainQueue]
                                          sender:nil
                                            task:block];
}

@end
