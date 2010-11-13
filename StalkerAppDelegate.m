//
//  StalkerAppDelegate.m
//

#import "StalkerAppDelegate.h"

#import "FeedStalker.h"
#import "FeedGrouper.h"
#import "Reachability.h"

@interface StalkerAppDelegate (Private)

+ (NSImage *)onlineImage;
+ (NSImage *)offlineImage;
+ (NSImage *)unknownImage;

- (void)setStatus:(StalkerStatus)status;

@end

@implementation StalkerAppDelegate

@synthesize window;
@synthesize table;
@synthesize configurePanel;
@synthesize feedArrayController;
@synthesize statusImage;
@synthesize grouper = _grouper;
@synthesize statusIndicator = _statusIndicator;

+ (NSImage *)onlineImage
{
    static NSImage *image = nil;
    
    if (!image)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Status-Online" ofType:@"png"];
        image = [[NSImage alloc] initWithContentsOfFile:path];
    }
    
    return [image autorelease];
}

+ (NSImage *)offlineImage
{
    static NSImage *image = nil;
    
    if (!image)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Status-Unavailable" ofType:@"png"];
        image = [[NSImage alloc] initWithContentsOfFile:path];
    }
    
    return [image autorelease];
    
}

+ (NSImage *)unknownImage
{
    static NSImage *image = nil;
    
    if (!image)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Status-Unknown" ofType:@"png"];
        image = [[NSImage alloc] initWithContentsOfFile:path];
    }
    
    return [image autorelease];
}

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        _client = [[PSClient applicationClient] retain];        
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunched"])
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunched"];
            
            NSURL *url = [NSURL URLWithString:@"feed://feeds.nytimes.com/nyt/rss/HomePage"];
            
            [_client addFeedWithURL:url];
            
            url = [NSURL URLWithString:@"feed://feeds.nytimes.com/nyt/rss/companies"];
            
            [_client addFeedWithURL:url];
        }
        
        _grouper            = [[FeedGrouper alloc] init];
        _hostReach          = nil;
        _statusIndicator    = nil;
    }
    
    return self;
}

- (void) dealloc
{
    [_client release];
    [_grouper release];
    [_hostReach release];
    [_statusIndicator release];
    [super dealloc];
}


- (void)awakeFromNib
{    
    [[self feedArrayController] setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
    
    [statusImage bind:@"image"
             toObject:self
          withKeyPath:@"statusIndicator"
              options:nil];
        
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    [self setStatus:StalkerUnknown];
    
    _hostReach = [[Reachability reachabilityWithHostName: @"www.craigslist.org"] retain];
	[_hostReach startNotifier];
}


- (void)setStatus:(StalkerStatus)status
{
    if (status == _status) 
    {
        return;
    }
    
    [self willChangeValueForKey:@"statusIndicator"];
    
    _status = status;
    

    switch (_status) 
    {
        case StalkerOnline:
            _statusIndicator = [[StalkerAppDelegate onlineImage] retain];
            break;
        case StalkerOffline:
            _statusIndicator = [[StalkerAppDelegate offlineImage] retain];
            break;
        case StalkerUnknown:
            _statusIndicator = [[StalkerAppDelegate unknownImage] retain];
            break;
        default:
            NSLog(@"Unknown status passed");
            break;
    }
    
    
    [self didChangeValueForKey:@"statusIndicator"];
}

- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);

    if(curReach == _hostReach)
	{
        NetworkStatus netStatus = [curReach currentReachabilityStatus];

        if(netStatus != NotReachable)
        {
            [self setStatus:StalkerOnline];
        }
        else 
        {
            [self setStatus:StalkerOffline];
        }

    }

}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{
//    [_client sendChangesSinceDate:[NSDate distantPast]];
    
    for(PSFeed *feed in [_client feeds])
    {
        [_grouper addFeed:[[[FeedStalker alloc] initWithFeed:feed] autorelease]];
    }
    
    [_grouper loadFeeds];
}

- (IBAction)refresh:(id)sender
{
    [_grouper refreshFeeds];
}

- (IBAction)configure:(id)sender
{
    [NSApp beginSheet: configurePanel
       modalForWindow: window
        modalDelegate: nil
       didEndSelector: nil
          contextInfo: nil];
    
    [NSApp runModalForWindow: configurePanel];
    
    // Dialog is up here.
    
    [NSApp endSheet: configurePanel];
    [configurePanel orderOut: self];
}

- (IBAction)closeConfigure:(id)sender
{
    [NSApp stopModal];
}

- (IBAction)markAllEntriesAsRead:(id)sender
{
    [_grouper markAllEntriesAs:YES];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    [window makeKeyAndOrderFront:self];
    return YES;
}


@end
