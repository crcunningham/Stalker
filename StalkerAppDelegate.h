//
//  StalkerAppDelegate.h
//

#import <Cocoa/Cocoa.h>
#import <PubSub/PubSub.h>

typedef enum StalkerStatus
{
    StalkerOnline = 1,
    StalkerOffline,
    StalkerUnknown
} StalkerStatus;

@class FeedGrouper;
@class Reachability;

@interface StalkerAppDelegate : NSObject <NSApplicationDelegate> 
{

@private
    FeedGrouper     *_grouper;
    PSClient        *_client;
    NSImage         *_statusIndicator;
    StalkerStatus   _status;
    Reachability    *_hostReach;
}

@property (nonatomic, assign) IBOutlet NSWindow *window;
@property (nonatomic, assign) IBOutlet NSTableView *table;
@property (nonatomic, assign) IBOutlet NSPanel *configurePanel;
@property (nonatomic, assign) IBOutlet NSArrayController *feedArrayController;
@property (nonatomic, assign) IBOutlet NSImageView *statusImage;
@property (readonly) FeedGrouper *grouper;
@property (readonly) NSImage *statusIndicator;

- (IBAction)refresh:(id)sender;
- (IBAction)configure:(id)sender;
- (IBAction)closeConfigure:(id)sender;
- (IBAction)markAllEntriesAsRead:(id)sender;

@end
