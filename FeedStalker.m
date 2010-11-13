//
//  FeedStalker.m
//

#import "FeedStalker.h"

#import "FeedEntry.h"

@interface FeedStalker (Private)

- (void)notifyFeedChange;
- (void)setupFeedObserving;
- (void)updateRefreshing;
- (void)updateUnreadCount;

@end

@implementation FeedStalker

@synthesize feedEntries     = _feedEntries;
@synthesize isRefreshing    = _refreshing;
@synthesize feedID;

- (id) initWithFeed:(PSFeed *)feed
{
    self = [super init];
    if (self != nil) 
    {
        _feed           = [feed retain];
        _url            = [[feed URL] retain];
        _queue          = [[NSOperationQueue alloc] init];
        _error          = nil;
        _note           = nil;
        _feedEntries    = [[NSMutableSet alloc] init];
        feedID          = -1;
        _refreshing     = NO;
        _unreadCount    = 0;
        
        [_queue setName:@"com.FeedStalker.queue"];
        
        [self setupFeedObserving];
        [self updateUnreadCount];
        [self updateRefreshing];
    }
    return self;
}

- (void) dealloc
{
    [_url release];
    [_feed release];
    [_feedEntries release];
    
    [_queue cancelAllOperations];
    [_queue release];
    
    [super dealloc];
}

- (void)setupFeedObserving
{
    // Feed Refresh
    void (^feedRefreshBlock)(NSNotification*) = ^(NSNotification *note) 
    { 
        [self performSelectorOnMainThread:@selector(updateRefreshing)
                               withObject:nil
                            waitUntilDone:NO];
        
        if ([_feed isRefreshing])
        {
            return;
        }
        
        [self performSelectorOnMainThread:@selector(notifyFeedChange)
                               withObject:nil
                            waitUntilDone:NO];
    }; 
    
    [[NSNotificationCenter defaultCenter] addObserverForName:PSFeedRefreshingNotification
                                                      object:_feed
                                                       queue:_queue
                                                  usingBlock:feedRefreshBlock];

    // Feed Changes
    void (^feedChangeBlock)(NSNotification*) = ^(NSNotification *note) 
    { 
        
        [self performSelectorOnMainThread:@selector(updateUnreadCount)
                               withObject:nil
                            waitUntilDone:NO];
    }; 
    
    [[NSNotificationCenter defaultCenter] addObserverForName:PSFeedEntriesChangedNotification
                                                      object:_feed
                                                       queue:_queue
                                                  usingBlock:feedChangeBlock];
}

- (void)updateRefreshing
{
    BOOL refresh = [_feed isRefreshing];
    
    if (_refreshing != refresh)
    {
        [self willChangeValueForKey:@"isRefreshing"];
        _refreshing = refresh;
        [self didChangeValueForKey:@"isRefreshing"];
    }
}

- (void)updateUnreadCount
{
    NSInteger unread = [_feed unreadCount];
    
    if (unread != _unreadCount)
    {
        [self willChangeValueForKey:@"unreadCount"];
        _unreadCount = unread;
        NSLog(@"Unread count for: %d is %d %d", feedID, _unreadCount, [_feed unreadCount]);
        [self didChangeValueForKey:@"unreadCount"];
    }
}

- (void)refreshFeed
{
    if(![_feed isRefreshing])
    {
        [_feed refresh:&_error];
        
        if(_error)
            NSLog(@"%@", _error);
    }
}

- (void)loadFeed
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
                        
    NSEnumerator *entries = [_feed entryEnumeratorSortedBy:nil];
    PSEntry *entry;
    
    [self willChangeValueForKey:@"feedEntries"];
    
    // Go through each entry and get the title, and description
    while (entry = [entries nextObject]) 
    {
        NSLog(@"%@" ,entry);

        
        FeedEntry *e = [FeedEntry entryWithPSEntry:entry];
        [e setFeedID:feedID];
        [_feedEntries addObject:e];
    } 
    
    [self didChangeValueForKey:@"feedEntries"];
    
    [self updateUnreadCount];
                        
    [pool drain];

}
     
- (void)notifyFeedChange
{
    
    NSAssert([[NSThread currentThread] isMainThread], @"Notifcations should be on the main thread");
    
    if (_error) 
    {
        [NSApp presentError:_error];
        return;
    }

    NSAutoreleasePool *pool = [NSAutoreleasePool new];

    // Update the feed entries
    [self willChangeValueForKey:@"feedEntries"];
    
    NSEnumerator *entries = [_feed entryEnumeratorSortedBy: nil];
    PSEntry *entry;

    
    NSLog(@"%@", _feed);
    NSLog(@"%@", entries);
    
    // Go through each entry and get the title, and description
    while (entry = [entries nextObject]) 
    {
        NSLog(@"%@" ,entry);
        
        if ([[entry datePublished] isGreaterThan:[_feed dateUpdated]])
        {
            FeedEntry *e = [FeedEntry entryWithPSEntry:entry];
            [e setFeedID:feedID];
            [_feedEntries addObject:e];

        }
    }

    [self didChangeValueForKey:@"feedEntries"];    
    
    [pool drain];
}

- (NSInteger)unreadCount
{
    return _unreadCount;
}

@end
