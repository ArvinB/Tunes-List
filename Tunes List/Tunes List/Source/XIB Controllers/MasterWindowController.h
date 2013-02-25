//
// << Add Legal Copyright Here >>
//

@class MasterViewController;

@interface MasterWindowController : NSWindowController

@property (readwrite, strong, nonatomic) NSString *masterWindowTitle;
@property (readwrite, strong, nonatomic) MasterViewController *masterViewController;

@end
