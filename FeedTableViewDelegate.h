//
//  FeedTableViewDelegate.h
//


#import <Cocoa/Cocoa.h>

#import "FeedTableView.h"

@interface FeedTableViewDelegate : NSObject <NSTableViewDelegate, FeedTableViewDelegate> 
{
    NSArrayController   *tableController;
}

@property (nonatomic, retain) IBOutlet NSArrayController *tableController;

@end
