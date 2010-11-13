//
//  FeedGrouper.h
//

#import <Cocoa/Cocoa.h>

@class FeedStalker;

@interface FeedGrouper : NSObject {


@private
    NSInteger       _refreshingCount;
    NSInteger       _unreadCount;
    NSMutableSet    *_allFeedEntries;
    NSMutableArray  *_feeds;

}

@property (readonly) NSMutableSet *allFeedEntries;
@property (readonly) NSArray *feeds;
@property (readonly) NSInteger refreshing;

- (void)addFeed:(FeedStalker *)feed;
- (void)loadFeeds;
- (void)refreshFeeds;
- (void)markAllEntriesAs:(BOOL)read;

@end
