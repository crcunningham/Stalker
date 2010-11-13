//
//  FeedStalker.h
//

#import <Cocoa/Cocoa.h>
#import <PubSub/PubSub.h>
#import <libkern/OSAtomic.h>


@interface FeedStalker : NSObject 
{

    NSInteger           feedID;
    
@private
    
    NSURL               *_url;
    PSFeed              *_feed;
	NSOperationQueue    *_queue;
	NSError             *_error;
	NSNotification      *_note;
    NSMutableSet        *_feedEntries;
    BOOL                _refreshing;
    NSInteger           _unreadCount;
}

@property (readonly) NSSet *feedEntries;
@property (readonly) BOOL isRefreshing;
@property (readonly) NSInteger unreadCount;
@property NSInteger feedID;


- (id) initWithFeed:(PSFeed *)feed;
- (void)refreshFeed;
- (void)loadFeed;

@end
