//
// << Add Legal Copyright Here >>
//

@class TunesObjects;

@interface TunesTrack : NSObject
@property (readonly, strong, nonatomic) NSString *uniqueID;
@property (readonly, strong, nonatomic) NSString *name;
@property (readonly, strong, nonatomic) NSString *location;
@property (readonly, strong, nonatomic) NSNumber *trackID;
@property (readonly, nonatomic, getter=hasVideo) BOOL video;
@end

@interface TunesTracks : NSObject

@property (readonly, strong, nonatomic) NSSet *audioTracks;
@property (readonly, strong, nonatomic) NSSet *videoTracks;
@property (readonly, strong, nonatomic) NSSet *allTracks;
@property (readonly, strong, nonatomic) NSSet *allTrackObjects;

+ (id) tunesTracksForObjects:(TunesObjects *)objects;

@end