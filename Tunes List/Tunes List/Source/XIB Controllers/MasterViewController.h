//
// << Add Legal Copyright Here >>
//

@class MasterObjectControls;

@interface MasterViewController : NSViewController

@property (readonly, strong, nonatomic) IBOutlet MasterObjectControls *controls;

- (IBAction) masterSwitchAction:(id)sender;

@end
