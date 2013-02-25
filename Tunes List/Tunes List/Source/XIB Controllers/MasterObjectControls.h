//
// << Add Legal Copyright Here >>
//

typedef NS_ENUM(NSUInteger, SwitchState) {
	
	SwitchOnState  = 0,
	SwitchOffState = 1
};

@interface MasterObjectControls : NSObjectController

@property (readwrite, nonatomic) SwitchState masterSwitchState;
@property (readwrite, nonatomic, getter=isControlsLocked) BOOL lockControls;
@property (readwrite, strong, nonatomic) NSString *statusMessage;

@property (readwrite, strong, nonatomic) IBOutlet NSProgressIndicator *masterProgress;
@property (readwrite, strong, nonatomic) IBOutlet NSTextField *masterStatus;
@property (readwrite, strong, nonatomic) IBOutlet NSSegmentedControl *masterSwitch;

- (void) setTempStatusMessage:(NSString *)strStatus;

@end
