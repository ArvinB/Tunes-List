//
// << Add Legal Copyright Here >>
//

#ifndef TUNES
	#define TUNES [TunesManager sharedTunesManager]
#endif

#define TunesLocalizedString(key) \
[[NSBundle mainBundle] localizedStringForKey:key value:@"" table:@"Tunes"]

static NSTimeInterval const kTunesDelay = 15;
static NSString* const kTunesNoteNameSourceSaved = @"com.apple.iTunes.sourceSaved";