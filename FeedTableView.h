//
//  FeedTableView.h
//


#import <Cocoa/Cocoa.h>

@protocol FeedTableViewDelegate

- (void)handleDoubleActionForRow:(NSInteger)row;

@end

@interface FeedTableView : NSTableView 
{

}

@end
