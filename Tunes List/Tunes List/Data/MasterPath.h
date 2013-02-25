//
// << Add Legal Copyright Here >>
//

@interface MasterPath : NSObject

+ (NSURL *) iTunesURL;
+ (NSURL *) iPhotoURL;

@end

@interface NSURL (CategoryMasterPath)

@property (readonly, strong, nonatomic) NSDictionary* pListDict;
+ (NSURL *) preferencesPOSIXURL;

@end