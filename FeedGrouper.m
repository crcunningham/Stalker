//
//  FeedGrouper.m
//

#import "FeedGrouper.h"

#import "FeedStalker.h"
#import "FeedEntry.h"

@interface FeedGrouper (Private)

- (void)updateBadgeCount;

@end

@implementation FeedGrouper

@synthesize allFeedEntries  = _allFeedEntries;
@synthesize feeds           = _feeds;
@synthesize refreshing      = _refreshingCount;

- (id) init
{
    self = [super init];
    
    if (self != nil) 
    {
        _allFeedEntries      = [[NSMutableSet alloc] init];
        _feeds               = [[NSMutableArray alloc] init];
        _refreshingCount     = 0;
        _unreadCount         = 0;
    }
    
    return self;
}

- (void) dealloc
{
    [_allFeedEntries release];
    [_feeds release];
    
    [super dealloc];
}

- (void)addFeed:(FeedStalker *)feed
{
    
    [feed setFeedID:[_feeds count]];
    
    [self willChangeValueForKey:@"feeds"];
    
    [_feeds addObject:feed];
    
    [self didChangeValueForKey:@"feeds"];
    
    [feed addObserver:self
           forKeyPath:@"unreadCount"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:nil];
    
    [feed addObserver:self
           forKeyPath:@"feedEntries"
              options:NSKeyValueObservingOptionNew
              context:nil];
    
    [feed addObserver:self
           forKeyPath:@"isRefreshing"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:nil];

    // Add the inital unread count, avoiding duplicates
    NSMutableSet *copy = [_allFeedEntries mutableCopy];

    [feed loadFeed];
    
   [copy intersectSet:[feed feedEntries]];
    
    NSLog(@"There are %d copies", [copy count]);
    
    _unreadCount += [feed unreadCount] - [copy count];

    [self updateBadgeCount];
}

- (void)loadFeeds
{
    for(FeedStalker *feed in _feeds)
    {
        [feed loadFeed];
    }
}

- (void)refreshFeeds
{
    for(FeedStalker *feed in _feeds)
    {
        [feed refreshFeed];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"feedEntries"])
    {
        [self willChangeValueForKey:@"allFeedEntries"];

        for(FeedStalker *feed in _feeds)
        {
            [_allFeedEntries unionSet:[feed feedEntries]];
        }
        
        [self didChangeValueForKey:@"allFeedEntries"];   
        
    }
    else if([keyPath isEqualToString:@"isRefreshing"])
    {
        NSNumber *new = [change objectForKey:NSKeyValueChangeNewKey];
        NSNumber *old = [change objectForKey:NSKeyValueChangeOldKey];
        
        if(old && new)
        {
            BOOL was = [old boolValue];
            BOOL is  = [new boolValue];
            
            if(was != is)
            {
                [self willChangeValueForKey:@"refreshing"];
                
                if(is)
                {
                    _refreshingCount++;
                }
                else
                {
                    _refreshingCount--;
                }

                [self didChangeValueForKey:@"refreshing"];
            }
        }
    }
    else if([keyPath isEqualToString:@"unreadCount"])
    {
        NSNumber *new = [change objectForKey:NSKeyValueChangeNewKey];
        NSNumber *old = [change objectForKey:NSKeyValueChangeOldKey];
        
        if(old && new)
        {
            NSInteger was = [old integerValue];
            NSInteger is  = [new integerValue];
            
            if(was != is)
            {
                _unreadCount += is - was;   
                [self updateBadgeCount];
            }
        }
    }
    
}


- (void)updateBadgeCount
{
    NSDockTile *tile = [[NSApplication sharedApplication] dockTile];

    if (_unreadCount > 0)
    {
        [tile setBadgeLabel:[NSString stringWithFormat:@"%ld", _unreadCount]];
    }
    else
    {
        [tile setBadgeLabel:@""];
    }

}

- (void)markAllEntriesAs:(BOOL)read
{
    for(FeedEntry *e in _allFeedEntries)
    {
        [e setIsRead:read];
    }
}

@end
