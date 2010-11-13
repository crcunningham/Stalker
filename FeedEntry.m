//
//  FeedEntry.m
//

#import "FeedEntry.h"


@implementation FeedEntry

@synthesize title;
@synthesize description;
@synthesize date;
@synthesize isRead;
@synthesize feedID;


+ (FeedEntry *)entryWithPSEntry:(PSEntry *)entry
{
    return [[[FeedEntry alloc] initWithEntry:entry] autorelease];
}

- (id) initWithEntry:(PSEntry *)entry
{
    self = [super init];
    if (self != nil)
    {
        _entry      = [entry retain];
        feedID      = -1;        
    }
    return self;
}

- (void) dealloc
{
    [_entry release];
    [title release];
    [description release];
    
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
    FeedEntry *copy = [[FeedEntry alloc] initWithEntry:_entry]; 
    [copy setFeedID:feedID];
    return copy;
}

- (NSDate *)date
{
    return [_entry dateForDisplay];
}

- (NSURL *)url
{
    return [_entry alternateURL];
}

- (NSString *)description
{
    return [[_entry content] plainTextString];
}

- (NSString *)title
{
    return [_entry title];
}

- (BOOL)isRead
{
    return [_entry isRead];
}

- (void)setIsRead:(BOOL)read
{
    [_entry setRead:read];
}

- (BOOL)isEqual:(id)object
{
    BOOL is;
    
    if(![object isKindOfClass:[FeedEntry class]])
    {
        is = NO;
    }
    else
    {
        if ([[self url] isEqual:[object url]])
        {
            is = YES;
        }
        else
        {
            is = NO;
        }

    }

    return is;
}

- (NSUInteger)hash
{
    return [[self url] hash];
}


@end
