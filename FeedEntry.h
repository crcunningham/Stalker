//
//  FeedEntry.h
//

#import <Cocoa/Cocoa.h>

#import <PubSub/PubSub.h>

@interface FeedEntry : NSObject <NSCopying> 
{
    NSInteger   feedID;
@private
    PSEntry *_entry;    
}

@property (readonly) NSString *description;
@property (readonly) NSString *title;
@property (readonly) NSDate *date;
@property (readonly) NSURL *url;
@property NSInteger feedID;
@property BOOL isRead;

+ (FeedEntry *)entryWithPSEntry:(PSEntry *)entry;

- (id) initWithEntry:(PSEntry *)entry;

@end
